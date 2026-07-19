let rec substitute variable replacement term =
  match term with
  | Term.Variable identifier ->
      if Identifier.equal identifier variable then
        replacement
      else
        term

  | Term.Application (left, right) ->
      Term.Application
        ( substitute variable replacement left,
          substitute variable replacement right )

  | Term.Lambda (identifier, body) ->
      if Identifier.equal identifier variable then
        term
      else
        Term.Lambda
          ( identifier,
            substitute variable replacement body )