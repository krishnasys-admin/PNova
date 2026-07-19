let check_identifiers expected actual =
  let to_strings ids =
    List.map Identifier.to_string ids
    |> List.sort String.compare
  in

  Alcotest.(check (list string))
    "same identifiers"
    (to_strings expected)
    (to_strings actual)

let test_variable () =
  let term = Term.var "x" in

  check_identifiers
    [ Identifier.of_string "x" ]
    (Free_variables.free term)

let test_lambda () =
  let term =
    Term.lambda "x" (Term.var "x")
  in

  check_identifiers
    []
    (Free_variables.free term)

let test_lambda_with_free_variable () =
  let term =
    Term.lambda
      "x"
      (Term.apply
         (Term.var "x")
         (Term.var "y"))
  in

  check_identifiers
    [ Identifier.of_string "y" ]
    (Free_variables.free term)

let test_nested_lambda () =
  let term =
    Term.lambda
      "x"
      (Term.lambda
         "y"
         (Term.apply
            (Term.apply
               (Term.var "x")
               (Term.var "y"))
            (Term.var "z")))
  in

  check_identifiers
    [ Identifier.of_string "z" ]
    (Free_variables.free term)

let () =
  Alcotest.run
    "PNova Free Variables"
    [
      ( "Free variables",
        [
          Alcotest.test_case "variable" `Quick test_variable;
          Alcotest.test_case "lambda" `Quick test_lambda;
          Alcotest.test_case
            "lambda with free variable"
            `Quick
            test_lambda_with_free_variable;
          Alcotest.test_case
            "nested lambda"
            `Quick
            test_nested_lambda;
        ] );
    ]