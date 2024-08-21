(*
(** Download a webpage. *)
let download host path =
  let addr = Unix.gethostbyname host in
  let sock_addr = Unix.ADDR_INET (addr.Unix.h_addr_list.(0), 80) in
  let sock = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  Unix.connect sock sock_addr;
  let request = Printf.sprintf "GET %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n" path host in
  Printf.printf "request: %s\n%!" request;
  assert (Unix.write_substring sock request 0 (String.length request) = String.length request);
  let buffer = Buffer.create 0 in
  let rec read () =
    let buflen = 4096 in
    let buf = Bytes.create buflen in
    let n = Unix.read sock buf 0 buflen in
    if n > 0 then
      (
        Buffer.add_subbytes buffer buf 0 n;
        read ()
      )
  in
  read ();
  Unix.close sock;
  Buffer.to_bytes buffer |> Bytes.to_string
*)

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
  query ?hits kind q |> Yojson.Basic.from_string

let json_assoc k = function
  | `Assoc a -> List.assoc k a
  | _ -> failwith ("Assoc expected when looking for key " ^ k)

let json_hits json =
  json |> json_assoc "result" |> json_assoc "hits"

type author =
  {
    name : string;
    url : string;
  }

let author ?hits name =
  let _json = query_json ?hits `Author name |> json_hits in
  assert false
