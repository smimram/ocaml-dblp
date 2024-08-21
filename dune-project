(lang dune 3.15)
(name dblp)
(generate_opam_files true)
(source (github smimram/ocalm-dblp))
(authors "Samuel Mimram")
(maintainers "Samuel Mimram")
(license LGPL-3.0)

(documentation https://smimram.github.io/ocaml-dblp/)

(package
 (name dblp)
 (synopsis "Library to query the DBLP bibliographic database")
 (description "The library provides helper functions to query the DBLP bibliographic database (authors, publications, and venue).")
 (depends cohttp cohttp-lwt-unix tls-lwt yojson)
)

(package
 (name dblp-cmdline)
 (synopsis "Commandline program do query the DBLP bibliographic database")
 (description "Program to query the DBLP bibliographic database and find authors, publications, and venues. It is particularily useful in order to retrieve bibtex entries.")
 (depends dblp)
)

