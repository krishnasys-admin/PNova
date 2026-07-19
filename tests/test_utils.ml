open Alcotest

let test_identifier () =
  let id = Identifier.of_string "x" in
  check string
    "identifier converts back to string"
    "x"
    (Identifier.to_string id)

let test_location () =
  let loc = Location.initial "example.pnv" in  (* Fixed file location *)
  check string
    "initial location"
    "example.pnv:1:1"
    (Location.to_string loc)

let () =
  run "PNova Utils"
    [
      ( "Identifier",
        [
          test_case "create identifier" `Quick test_identifier;
        ] );
      ( "Location",
        [
          test_case "initial location" `Quick test_location;
        ] );
    ] 

let test_fresh () =
  let generator = Fresh.create () in

  let first =
    Fresh.next generator "x"
    |> Identifier.to_string
  in

  let second =
    Fresh.next generator "x"
    |> Identifier.to_string
  in

  Alcotest.(check string)
    "first fresh identifier"
    "x_0"
    first;

  Alcotest.(check string)
    "second fresh identifier"
    "x_1"
    second;

  Fresh.reset generator;

  let reset_value =
    Fresh.next generator "x"
    |> Identifier.to_string
  in

  Alcotest.(check string)
    "reset identifier"
    "x_0"
    reset_value

let () =
  Alcotest.run "PNova Utils"
    [
      (
        "Identifier",
        [
          Alcotest.test_case
            "conversion"
            `Quick
            test_identifier;
        ]
      );

      (
        "Location",
        [
          Alcotest.test_case
            "initial position"
            `Quick
            test_location;
        ]
      );

      (
        "Fresh",
        [
          Alcotest.test_case
            "unique generation"
            `Quick
            test_fresh;
        ]
      );
    ]