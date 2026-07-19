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