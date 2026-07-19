let rec rename old_id new_id term =
  match term with
  | Term.Variable id ->
      if Identifier.equal id old_id then
        Term.var_id new_id
      else
        term

  | Term.Application (left, right) ->
      Term.apply
        (rename old_id new_id left)
        (rename old_id new_id right)

  | Term.Lambda (id, body) ->
      if Identifier.equal id old_id then
        Term.lambda_id id body
      else
        Term.lambda_id id (rename old_id new_id body)


let rec substitute variable replacement term =
  match term with
  | Term.Variable id ->
      if Identifier.equal id variable then
        replacement
      else
        term

  | Term.Application (left, right) ->
      Term.apply
        (substitute variable replacement left)
        (substitute variable replacement right)

  | Term.Lambda (id, body) ->
      if Identifier.equal id variable then
        term
      else
        let replacement_fv =
          Free_variables.free replacement
        in

        if List.exists
             (Identifier.equal id)
             replacement_fv
        then
          let fresh_id =
            Fresh.next
              (Fresh.create ())
              (Identifier.to_string id)
          in

          let renamed_body =
            rename id fresh_id body
          in

          Term.lambda_id
            fresh_id
            (substitute variable replacement renamed_body)
        else
          Term.lambda_id
            id
            (substitute variable replacement body)