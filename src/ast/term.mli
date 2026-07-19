(** Core lambda calculus expressions. *)

type t =
  | Variable of Identifier.t
  | Lambda of Identifier.t * t
  | Application of t * t

(** Creates a variable term. *)
val var : string -> t

(** Creates a lambda abstraction. *)
val lambda : string -> t -> t

(** Creates a function application. *)
val apply : t -> t -> t

(** Returns a readable representation of a term. *)
val to_string : t -> string