let rec reduce term =
  match term with
  | Term.Application (Term.Lambda (identifier, body), argument) ->
      Some (Substitution.substitute identifier argument body)

  | Term.Application (left, right) -> (
      match reduce left with
      | Some left' ->
          Some (Term.apply left' right)
      | None ->
          match reduce right with
          | Some right' ->
              Some (Term.apply left right')
          | None ->
              None )

  | Term.Lambda (identifier, body) -> (
      match reduce body with
      | Some body' ->
          Some (Term.lambda_id identifier body')
      | None ->
          None )

  | Term.Variable _ ->
      None