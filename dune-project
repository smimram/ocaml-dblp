(lang dune 2.9)
(name dblp)
(version 0.1.0)
(generate_opam_files true)
(source (github smimram/ocalm-dblp))
(authors "Samuel Mimram")
(maintainers "Samuel Mimram")
(license LGPL-3.0-or-later)

(documentation https://smimram.github.io/ocaml-dblp/)

(package
 (name dblp-api)
 (synopsis "Library to query the DBLP bibliographic database")
 (description "The library provides helper functions to query the DBLP bibliographic database (authors, publications, and venue).")
 (depends cohttp cohttp-lwt-unix ssl-lwt yojson)
)

(package
 (name dblp)
 (synopsis "Commandline program do query the DBLP bibliographic database")
 (description "Program to query the DBLP bibliographic database and find authors, publications, and venues. It is particularily useful in order to retrieve bibtex entries.")
 (depends dblp-api)
)

