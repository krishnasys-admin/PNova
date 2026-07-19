let test_variable () =
  let term = Term.var "x" in

  Alcotest.(check string)
    "variable"
    "x"
    (Term.to_string term)


let test_lambda () =
  let term =
    Term.lambda "x" (Term.var "x")
  in

  Alcotest.(check string)
    "lambda"
    "λx. x"
    (Term.to_string term)


let test_application () =
  let term =
    Term.apply
      (Term.var "f")
      (Term.var "x")
  in

  Alcotest.(check string)
    "application"
    "(f x)"
    (Term.to_string term)


let () =
  Alcotest.run "PNova AST"
    [
      (
        "Terms",
        [
          Alcotest.test_case
            "variable"
            `Quick
            test_variable;

          Alcotest.test_case
            "lambda"
            `Quick
            test_lambda;

          Alcotest.test_case
            "application"
            `Quick
            test_application;
        ]
      )
    ]
    