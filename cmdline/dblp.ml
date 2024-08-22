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

let () =
  let cmd = ref "" in
  let args = ref [] in
  let hits = ref None in
  let doi = ref false in
  let arg_speclist =
    [
      "--doi", Arg.Set doi, "Show doi.";
      "--hits", Arg.Int (fun n -> hits := Some n), "Maximal number of hits (search results)."
    ]
  in
  let arg_usage = "dblp command arguments" in
  Arg.parse
    arg_speclist
    (fun s -> if !cmd = "" then cmd := s else args := s :: !args)
    arg_usage;
  let cmd = !cmd in
  let args = !args |> List.rev |> String.concat " " in
  let hits = !hits in
  if cmd = "" then error "Please provide a command.";
  let print_publications ?(doi = !doi) l =
    List.iteri
      (fun i p ->
         Printf.printf "%s%d. %s\n%!" (if i < 9 then " " else "") (i+1) (DBLP.string_of_publication p);
         if doi then
           (
             let doi = p.DBLP.publication_doi in
             if doi <> "" then print_string ("    http://doi.org/" ^ doi ^ "\n")
           )
      ) l
  in
  let publications () =
    let l = DBLP.publication ?hits args in
    if l = [] then no_result ();
    l
  in
  let publication () =
    let l = publications () in
    if List.length l = 1 then List.hd l
    else
      (
        print_publications l;
        select "publication" l
      )
  in
  match cmd with
  | "help" ->
    print_endline (Arg.usage_string arg_speclist arg_usage);
    exit 0
  | "publication"
  | "find" ->
    (* Find a publication. *)
    let l = publications () in
    print_publications l
  | "show" ->
    (* Display the publication using doi. *)
    let p = publication () in
    let doi = p.DBLP.publication_doi in
    Filename.quote_command "x-www-browser" ["http://doi.org/" ^ doi] |> Sys.command |> ignore
  | "bibtex" ->
    (* Find a bibtex. *)
    let p = publication () in
    print_string (p.DBLP.publication_bib ())
  | "bib" ->
    (* Same as bibtex but adds to the bib file in the current directory. *)
    let p = publication () in
    let bib = Sys.readdir "." |> Array.to_list |> List.filter (fun f -> Filename.extension f = ".bib") in
    let bib =
      match List.length bib with
      | 0 -> print_string "No bib file found in current directory, file to use: "; read_line ()
      | 1 -> List.hd bib
      | _ ->
        print_endline "Found the following .bib files:";
        List.iteri (fun i f -> Printf.printf "%d. %s\n%!" (i+1) f) bib;
        select "bib file" bib
    in
    Printf.printf "Adding the following entry to %s:\n\n%!" bib;
    let entry = p.DBLP.publication_bib () in
    print_string entry;
    let oc = open_out_gen [Open_wronly; Open_append; Open_creat] 0o644 bib in
    output_string oc "\n";
    output_string oc entry;
    close_out oc
  | "author" ->
    let l = DBLP.author ?hits args in
    if l = [] then no_result ();
    List.iter (fun a -> Printf.printf "%s: %s\n%!" a.DBLP.author_name a.DBLP.author_url) l
  | "venue" ->
    let l = DBLP.venue ?hits args in
    if l = [] then no_result ();
    List.iter (fun v -> Printf.printf "%s: %s (%s)\n%!" v.DBLP.venue_acronym v.DBLP.venue_name v.DBLP.venue_type) l
  | cmd -> error "Unknown command %s." cmd
