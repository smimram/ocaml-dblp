let error fmt =
  Printf.ksprintf (fun s -> output_string stderr (s ^ "\n"); exit 1) fmt

let no_result () =
  print_endline "No result.";
  exit 0

let select name l =
  let invalid () = error "Invalid %s number." name in
  Printf.printf "\nSelect %s (default is first): %!" name;
  let n = read_line () in
  print_newline ();
  let n = if n = "" then "1" else n in
  let n = try int_of_string n with _ -> invalid () in
  let n = n-1 in
  try List.nth l n with _ -> invalid ()

let print_publications l =
  List.iteri
    (fun i p ->
       Printf.printf "%d. %s\n%!" (i+1) (DBLP.string_of_publication p) 
    ) l

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
  let publications () =
    let l = DBLP.publication ?hits args in
    if l = [] then no_result ();
    l
  in
  match cmd with
  | "find" ->
    let l = publications () in
    print_publications l
  | "bibtex" ->
    let l = publications () in
    if List.length l = 1 then print_string ((List.hd l).DBLP.publication_bib ())
    else
      (
        print_publications l;
        let p = select "publication" l in
        print_string (p.DBLP.publication_bib ())
      )
  | "author" ->
    let l = DBLP.author ?hits args in
    if l = [] then no_result ();
    List.iter (fun a -> Printf.printf "%s: %s\n%!" a.DBLP.author_name a.DBLP.author_url) l
  | "venue" ->
    let l = DBLP.venue ?hits args in
    if l = [] then no_result ();
    List.iter (fun v -> Printf.printf "%s: %s (%s)\n%!" v.DBLP.venue_acronym v.DBLP.venue_name v.DBLP.venue_type) l
  | cmd -> error "Unknown command %s." cmd
