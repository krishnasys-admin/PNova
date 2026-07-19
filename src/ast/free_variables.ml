let rec free term =
  match term with
  | Term.Variable identifier ->
      [ identifier ]

  | Term.Application (left, right) ->
      union (free left) (free right)

  | Term.Lambda (identifier, body) ->
      remove identifier (free body)

and union left right =
  List.fold_left
    (fun acc identifier ->
      if List.exists (Identifier.equal identifier) acc then
        acc
      else
        identifier :: acc)
    left
    right

and remove identifier identifiers =
  List.filter
    (fun x -> not (Identifier.equal x identifier))
    identifiers