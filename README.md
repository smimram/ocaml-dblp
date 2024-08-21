# ocaml-dblp

OCaml library to use the API of the bibliographic [DBLP](http://dblp.org) database. It provides functions to search for

- authors
- publications
- venues

and should be fairly explicit and simple to use. To get started you can have a look at

- [the library documentation](https://smimram.github.io/ocaml-dblp/dblp/DBLP/)
- [a simple example program](test/test.ml)

## DBLP query program

We also provide a commandline program in order to query DBLP from the commandline. It can be installed with

```bash
opam install dblp-query
```

It provides the `dblp` program which takes as argument a command (the kind of query you want to make) and a query (a list of words to look for).

You can find a publication with the `find` command:

```
$ dblp find mimram type

1. Camil Champin, Samuel Mimram, Émile Oleon. Delooping Generated Groups in Homotopy Type Theory. FSCD, 6:1-6:20, 2024.
2. Samuel Mimram, Émile Oleon. Delooping cyclic groups with lens spaces in homotopy type theory. LICS, 56:1-56:15, 2024.
3. Camil Champin, Samuel Mimram, Émile Oleon. Delooping generated groups in homotopy type theory. CoRR, 2024.
4. Samuel Mimram, Émile Oleon. Delooping cyclic groups with lens spaces in homotopy type theory. CoRR, 2024.
5. Samuel Mimram, Émile Oleon. Division by Two, in Homotopy Type Theory. FSCD, 11:1-11:17, 2022.
6. Eric Finster, Samuel Mimram, Maxime Lucas, Thomas Seiller. A Cartesian Bicategory of Polynomial Functors in Homotopy Type Theory. MFPS, 67-83, 2021.
7. Thibaut Benjamin, Eric Finster, Samuel Mimram. Globular weak ω-categories as models of a type theory. CoRR, 2021.
8. Eric Finster, Samuel Mimram. A type-theoretical definition of weak ω-categories. LICS, 1-12, 2017.
9. Eric Finster, Samuel Mimram. A Type-Theoretical Definition of Weak ω-Categories. CoRR, 2017.
```

You can find a bibtex with the `bibtex` command:

```
$ dblp bibtex mimram type

1. Camil Champin, Samuel Mimram, Émile Oleon. Delooping Generated Groups in Homotopy Type Theory. FSCD, 6:1-6:20, 2024.
2. Samuel Mimram, Émile Oleon. Delooping cyclic groups with lens spaces in homotopy type theory. LICS, 56:1-56:15, 2024.
3. Camil Champin, Samuel Mimram, Émile Oleon. Delooping generated groups in homotopy type theory. CoRR, 2024.
4. Samuel Mimram, Émile Oleon. Delooping cyclic groups with lens spaces in homotopy type theory. CoRR, 2024.
5. Samuel Mimram, Émile Oleon. Division by Two, in Homotopy Type Theory. FSCD, 11:1-11:17, 2022.
6. Eric Finster, Samuel Mimram, Maxime Lucas, Thomas Seiller. A Cartesian Bicategory of Polynomial Functors in Homotopy Type Theory. MFPS, 67-83, 2021.
7. Thibaut Benjamin, Eric Finster, Samuel Mimram. Globular weak ω-categories as models of a type theory. CoRR, 2021.
8. Eric Finster, Samuel Mimram. A type-theoretical definition of weak ω-categories. LICS, 1-12, 2017.
9. Eric Finster, Samuel Mimram. A Type-Theoretical Definition of Weak ω-Categories. CoRR, 2017.

Select publication (default is first): 8

@inproceedings{DBLP:conf/lics/FinsterM17,
  author       = {Eric Finster and
                  Samuel Mimram},
  title        = {A type-theoretical definition of weak {\(\omega\)}-categories},
  booktitle    = {32nd Annual {ACM/IEEE} Symposium on Logic in Computer Science, {LICS}
                  2017, Reykjavik, Iceland, June 20-23, 2017},
  pages        = {1--12},
  publisher    = {{IEEE} Computer Society},
  year         = {2017},
  url          = {https://doi.org/10.1109/LICS.2017.8005124},
  doi          = {10.1109/LICS.2017.8005124},
  timestamp    = {Fri, 24 Mar 2023 00:01:49 +0100},
  biburl       = {https://dblp.org/rec/conf/lics/FinsterM17.bib},
  bibsource    = {dblp computer science bibliography, https://dblp.org}
}
```

The `bib` command does pretty much the same but also adds the entry at the end of the `.bib` file in the current directory:

```
$ dblp bib mimram type
```

You can find an author with the `author` command:

```
$ dblp author mimram

Samuel Mimram: https://dblp.org/pid/99/4962
```

You can find a venue:

```
$ dblp venue lics

LICS: ACM/IEEE Symposium on Logic in Computer Science (LICS) (Conference or Workshop)
```

## See also

- [dblp-python library](https://github.com/scholrly/dblp-python)
