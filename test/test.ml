open DBLP

let () =
  print_string "# Query authors\n\n";
  DBLP.author ~hits:5 "Girard" |>
  List.iter (fun a ->
      Printf.printf "%s : %s\n%!" a.author_name a.author_url
    );
  print_newline ()

let () =
  print_string "# Query publications\n\n";
  let l = DBLP.publication ~hits:10 "Mimram" in
  List.iter (fun p -> p |> string_of_publication |> print_string) l;
  print_newline ();
  print_string ((List.hd l).publication_bib ());

  
