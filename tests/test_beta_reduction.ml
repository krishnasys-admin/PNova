let test_identity () =
  let identity =
    Term.lambda "x" (Term.var "x")
  in

  let application =
    Term.apply identity (Term.var "y")
  in

  match Beta_reduction.reduce application with
  | None ->
      Alcotest.fail "Expected a reduction"

  | Some result ->
      Alcotest.(check string)
        "identity"
        "y"
        (Term.to_string result)

let () =
  Alcotest.run
    "PNova Beta Reduction"
    [
      ( "BetaReduction",
        [
          Alcotest.test_case
            "identity"
            `Quick
            test_identity;
        ] );
    ]