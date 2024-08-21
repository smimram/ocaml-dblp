let download url =
  let download url =
    let open Lwt in
    let open Cohttp in
    let open Cohttp_lwt_unix in
    Client.get (Uri.of_string url) >>= fun (resp, body) ->
    let code = resp |> Response.status |> Code.code_of_status in
    (* Printf.printf "Response code: %d\n" code; *)
    (* Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string); *)
    if code <> 200 then failwith (Printf.sprintf "Server response code was %d instead of expected 200" code);
    body |> Cohttp_lwt.Body.to_string >|= fun body ->
    body
  in
  Lwt_main.run (download url)

module JSON = struct
  let of_string = Yojson.Basic.from_string

  let list = function
    | `List l -> l
    | _ -> failwith "list expected"

  let assoc = function
    | `Assoc a -> a
    | _ -> failwith "assoc expected"

  let associate k json =
    json |> assoc |> List.assoc k

  let string = function
    | `String s -> s
    | _ -> failwith "string expected"
end

let query ?hits ?first ?completion kind query =
  let hits =
    match hits with
    | Some h -> "h=" ^ string_of_int h ^ "&"
    | None -> ""
  in
  let first =
    match first with
    | Some f -> "f=" ^ string_of_int f ^ "&"
    | None -> ""
  in
  let completion =
    match completion with
    | Some c -> "c=" ^ string_of_int c ^ "&"
    | None -> ""
  in
  let kind =
    match kind with
    | `Publication -> "publ"
    | `Author -> "author"
    | `Venue -> "venue"
  in
  let url = "https://dblp.org/search/" ^ kind ^ "/api?format=json&" ^ hits ^ first ^ completion ^ "q=" ^ query in
  download url

let query_json ?hits kind q =
  query ?hits kind q |> JSON.of_string

let json_hits json =
  json
  |> JSON.associate "result"
  |> JSON.associate "hits"
  |> JSON.associate "hit"
  |> JSON.list
  |> List.map (fun h -> h |> JSON.associate "info" |> JSON.assoc)

type author =
  {
    author_name : string;
    author_url : string;
  }

let author ?hits name =
  query_json ?hits `Author name |> json_hits |>
  List.map (fun author ->
      let find k = List.assoc k author |> JSON.string in
      {
        author_name = find "author";
        author_url = find "url";
      }
    )

type publication =
  {
    publication_authors : string list;
    publication_title : string;
    publication_venue : string;
    publication_pages : string;
    publication_year : int;
    publication_type : string;
    publication_key : string;
    publication_doi : string;
    publication_url : string;
    publication_ee : string;
    publication_access : string;
    publication_bib : unit -> string;
  }

let publication ?hits query =
  query_json ?hits `Publication query |> json_hits |>
  List.map (fun publication ->
      let find k = List.assoc_opt k publication |> Option.map JSON.string |> Option.value ~default:"" in
      let publication_authors =
        let author = List.assoc "authors" publication |> JSON.associate "author" in
        match author with
        | `List l -> List.map (fun a -> a |> JSON.associate "text" |> JSON.string) l
        | `Assoc a -> [List.assoc "text" a |> JSON.string]
        | _ -> assert false
      in
      let url = find "url" in
      {
        publication_authors;
        publication_title = find "title";
        publication_venue = find "venue";
        publication_pages = find "pages";
        publication_year = find "year" |> int_of_string;
        publication_type = find "type";
        publication_key = find "key";
        publication_doi = find "doi";
        publication_url = url;
        publication_ee = find "ee";
        publication_access = find "access";
        publication_bib = fun () -> download (url ^ ".bib")
      }
    )

let string_of_publication p =
  let authors = p.publication_authors |> String.concat ", " in
  let pages = if p.publication_pages = "" then "" else p.publication_pages ^ ", " in
  Printf.sprintf "%s. %s %s, %s%d.\n%!" authors p.publication_title p.publication_venue pages p.publication_year
