(** Capture-avoiding substitution for lambda calculus terms. *)

(** [substitute variable replacement term] replaces all free occurrences
    of [variable] in [term] with [replacement].

    This initial implementation handles the basic recursive rules.
*)
val substitute :
  Identifier.t ->
  Term.t ->
  Term.t ->
  Term.t