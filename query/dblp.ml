let error fmt =
  Printf.ksprintf (fun s -> output_string stderr s; exit 1) fmt

let () =
  let cmd = ref "" in
  let args = ref [] in
  let hits = ref None in
  Arg.parse
    [
      "--hits", Arg.Int (fun n -> hits := Some n), "Maximal number of hits (search results)."
    ]
    (fun s -> if !cmd = "" then cmd := s else args := s :: !args)
    "dblp command arguments";
  let cmd = !cmd in
  let args = !args |> List.rev |> String.concat " " in
  let hits = !hits in
  if cmd = "" then error "Please provide a command.";
  match cmd with
  | "find" ->
    let l = DBLP.publication ?hits args in
    List.iteri
      (fun i p ->
         Printf.printf "%d. %s\n%!" (i+1) (DBLP.string_of_publication p) 
      ) l
  | cmd -> error "Unknown command %s." cmd
