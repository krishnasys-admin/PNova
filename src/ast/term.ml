type t =
  | Variable of Identifier.t
  | Lambda of Identifier.t * t
  | Application of t * t

let var name =
  Variable (Identifier.of_string name)

let lambda name body =
  Lambda (Identifier.of_string name, body)

let apply function_term argument =
  Application (function_term, argument)

let rec to_string term =
  match term with
  | Variable name ->
      Identifier.to_string name
  | Lambda (name, body) ->
      "λ"
      ^ Identifier.to_string name
      ^ ". "
      ^ to_string body
  | Application (function_term, argument) ->
      "("
      ^ to_string function_term
      ^ " "
      ^ to_string argument
      ^ ")"