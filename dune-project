(lang dune 2.9)
(name dblp)
(version 0.1.1)
(generate_opam_files true)
(source (github smimram/ocaml-dblp))
(authors "Samuel Mimram <smimram@gmail.com>")
(maintainers "Samuel Mimram <smimram@gmail.com>")
(license LGPL-3.0-or-later)

(documentation https://smimram.github.io/ocaml-dblp/)

(package
 (name dblp-api)
 (synopsis "Library to query the DBLP bibliographic database")
 (description "The library provides helper functions to query the DBLP bibliographic database (authors, publications, and venue).")
 (depends
   (ocaml (>= 4.05))
   cohttp cohttp-lwt-unix lwt_ssl yojson)
)

(package
 (name dblp)
 (synopsis "Commandline program do query the DBLP bibliographic database")
 (description "Program to query the DBLP bibliographic database and find authors, publications, and venues. It is particularily useful in order to retrieve bibtex entries.")
 (depends
   (ocaml (>= 4.10))
   dblp-api
 )
)

