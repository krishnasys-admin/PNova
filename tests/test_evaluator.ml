let test_identity () =
  let identity =
    Term.lambda "x" (Term.var "x")
  in

  let term =
    Term.apply identity (Term.var "y")
  in

  let result =
    Evaluator.evaluate term
  in

  Alcotest.(check string)
    "evaluates to y"
    "y"
    (Term.to_string result)

let () =
  Alcotest.run
    "PNova Evaluator"
    [
      ( "Evaluator",
        [
          Alcotest.test_case
            "identity"
            `Quick
            test_identity;
        ] );
    ]