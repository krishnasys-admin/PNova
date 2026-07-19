open Alcotest

let test_substitution_variable () =
  let x = Identifier.of_string "x" in
  let y = Identifier.of_string "y" in

  let result =
    Substitution.substitute
      x
      (Term.var_id y)
      (Term.var_id x)
  in

  check string
    "substitute variable"
    "y"
    (Term.to_string result)

let test_substitution_bound_variable () =
  let x = Identifier.of_string "x" in
  let y = Identifier.of_string "y" in

  let term =
    Term.lambda_id
      x
      (Term.var_id x)
  in

  let result =
    Substitution.substitute
      x
      (Term.var_id y)
      term
  in

  check string
    "bound variable unchanged"
    "(λx.x)"
    (Term.to_string result)

let test_beta_reduction () =
  let x = Identifier.of_string "x" in
  let y = Identifier.of_string "y" in

  let term =
    Term.apply
      (Term.lambda_id x (Term.var_id x))
      (Term.var_id y)
  in

  match Beta_reduction.reduce term with
  | Some reduced ->
      check string
        "beta reduction"
        "y"
        (Term.to_string reduced)
  | None ->
      fail "expected reduction"

let test_evaluator () =
  let x = Identifier.of_string "x" in
  let y = Identifier.of_string "y" in

  let identity =
    Term.lambda_id x (Term.var_id x)
  in

  let term =
    Term.apply identity (Term.var_id y)
  in

  let result =
    Evaluator.evaluate term
  in

  check string
    "evaluation"
    "y"
    (Term.to_string result)

let () =
  run
    "Lambda"
    [
      ( "core",
        [
          test_case "substitution variable" `Quick test_substitution_variable;
          test_case "substitution bound variable" `Quick test_substitution_bound_variable;
          test_case "beta reduction" `Quick test_beta_reduction;
          test_case "evaluation" `Quick test_evaluator;
        ] );
    ]