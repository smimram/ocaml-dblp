(lang dune 3.15)
(name dblp)
(generate_opam_files true)
(source (github smimram/ocalm-dblp))
(authors "Samuel Mimram")
(maintainers "Samuel Mimram")
(license LGPL-3.0)

(documentation https://url/to/documentation)

(package
 (name dblp)
 (synopsis "Library to query the DBLP bibliographic database")
 (description "The library provides helper functions to query the DBLP bibliographic database (authors, publications, and venue).")
 (depends cohttp cohttp-lwt-unix yojson)
)

(package
 (name dblp-query)
 (synopsis "Commandline program do query the DBLP bibliographic database")
 (depends dblp)
)

