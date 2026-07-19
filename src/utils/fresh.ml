type t =
  {
    mutable counter : int;
  }

let create () =
  {
    counter = 0;
  }

let next generator prefix =
  let id =
    prefix ^ "_" ^ string_of_int generator.counter
  in
  generator.counter <- generator.counter + 1;
  Identifier.of_string id

let reset generator =
  generator.counter <- 0