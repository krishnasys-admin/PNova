(lang dune 3.24)

(name pnova)

(generate_opam_files true)

(source
 (github krishnasys-admin/PNova))

(authors "Krishna")

(maintainers "Krishna")

(license MIT)

(package
 (name pnova)
 (synopsis "Interactive theorem prover written in OCaml")
 (description
  "PNova is an interactive theorem prover built from first principles in OCaml.")
 (depends
  ocaml
  dune
  alcotest))