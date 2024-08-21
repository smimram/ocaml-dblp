open DBLP

let () =
  DBLP.author ~hits:5 "Girard" |>
  List.iter (fun a ->
      Printf.printf "%s : %s\n%!" a.author_name a.author_url
    )

(* let () = *)
  (* print_string (DBLP.download "https://www.google.fr") *)
  (* let s = DBLP.query `Author "Mimram" in *)
  (* let s = DBLP.query `Publication "Mimram" in *)
  (* print_string s *)

  
