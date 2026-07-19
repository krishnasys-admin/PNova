(** Computes the free variables of lambda calculus terms. *)

(** Returns the list of free variables in a term.

    Each identifier appears at most once in the result.
*)
val free : Term.t -> Identifier.t list