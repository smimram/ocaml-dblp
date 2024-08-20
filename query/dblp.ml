let () =
  let s = DBLP.query `Author "Mimram" in
  print_string s
