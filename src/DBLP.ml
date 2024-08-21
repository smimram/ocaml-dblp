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

type author =
  {
    author_name : string;
    author_url : string;
  }

let author ?hits name =
  query_json ?hits `Author name |> json_hits |>
  List.map (fun author ->
      let author = author |> JSON.associate "info" |> JSON.assoc in
      {
        author_name = List.assoc "author" author |> JSON.string;
        author_url = List.assoc  "url" author |> JSON.string
      }
    )
