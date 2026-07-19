(** Generates unique identifiers for internal compiler and prover operations. *)

type t

(** Creates a new fresh identifier generator. *)
val create : unit -> t

(** Generates a unique identifier using the given prefix. *)
val next : t -> string -> Identifier.t

(** Resets the generator counter to zero. *)
val reset : t -> unit