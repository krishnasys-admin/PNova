let test_empty () =
  Alcotest.(check bool)
    "empty"
    true
    (IdentifierSet.is_empty IdentifierSet.empty)

let test_add () =
  let set =
    IdentifierSet.empty
    |> IdentifierSet.add (Identifier.of_string "x")
  in

  Alcotest.(check bool)
    "contains x"
    true
    (IdentifierSet.mem (Identifier.of_string "x") set)

let test_duplicates () =
  let set =
    IdentifierSet.empty
    |> IdentifierSet.add (Identifier.of_string "x")
    |> IdentifierSet.add (Identifier.of_string "x")
  in

  Alcotest.(check int)
    "size"
    1
    (IdentifierSet.cardinal set)

let () =
  Alcotest.run
    "PNova IdentifierSet"
    [
      ( "IdentifierSet",
        [
          Alcotest.test_case "empty" `Quick test_empty;
          Alcotest.test_case "add" `Quick test_add;
          Alcotest.test_case "duplicates" `Quick test_duplicates;
        ] );
    ]