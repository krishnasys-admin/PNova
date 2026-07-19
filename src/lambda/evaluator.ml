let rec evaluate term =
  match Beta_reduction.reduce term with
  | Some reduced ->
      evaluate reduced
  | None ->
      term