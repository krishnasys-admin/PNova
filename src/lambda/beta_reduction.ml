let reduce term =
  match term with
  | Term.Application (Term.Lambda (identifier, body), argument) ->
      Some (Substitution.substitute identifier argument body)

  | _ ->
      None