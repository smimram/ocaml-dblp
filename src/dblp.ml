(** Download a webpage. *)
let download host path =
  let addr = Unix.gethostbyname host in
  let sock_addr = Unix.ADDR_INET (addr.Unix.h_addr_list.(0), 80) in
  let sock = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  Unix.connect sock sock_addr;
  let request = Printf.sprintf "GET %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n" path host in
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

let query ?hits ?first ?completion kind q =
  let hits =
    match hits with
    | Some h -> "h=" ^ string_of_int h
    | None -> ""
  in
  let first =
    match first with
    | Some f -> "f=" ^ string_of_int f
    | None -> ""
  in
  let completion =
    match completion with
    | Some c -> "c=" ^ string_of_int c
    | None -> ""
  in
  let kind =
    match kind with
    | `Publication -> "publ"
    | `Author -> "author"
    | `Venue -> "venue"
  in
  let host = "dblp.org" in
  let path = "search/" ^ kind ^ "/api?" ^ hits ^ "&" ^ first ^ "&" ^ completion ^ "&q=" ^ q in
  download host path
