(** Immutable identifiers used throughout PNova.

    Identifiers represent user-defined names such as variables,
    constants, and theorem names. *)

type t

(** Create an identifier from a string. *)
val of_string : string -> t

(** Convert an identifier to its string representation. *)
val to_string : t -> string

(** Test two identifiers for equality. *)
val equal : t -> t -> bool

(** Compare two identifiers.

    Returns:
    - a negative integer if the first identifier is smaller,
    - zero if they are equal,
    - a positive integer otherwise.
*)
val compare : t -> t -> int