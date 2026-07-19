let test_capture_avoidance () =
  let term =
    Term.lambda
      "y"
      (Term.var "x")
  in

  let result =
    Substitution.substitute
      (Identifier.of_string "x")
      (Term.var "y")
      term
  in

  Alcotest.(check string)
    "avoids capture"
    "(λy_0. y)"
    (Term.to_string result)