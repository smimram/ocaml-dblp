0.1.1 (2024-10-03)
=====

- Document commands.
- Depend on OCaml >= 4.10 because of the use of `Filename.quote_command`.
- Change dune test target from `runtest` to `citest` for tests requiring network
  in order to please opam automated tests (see
  <https://github.com/ocaml/opam-repository/pull/26631>).

0.1.0 (2024-09-27)
=====

- Initial release.
