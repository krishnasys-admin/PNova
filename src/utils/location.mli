type t = {
  filename : string;
  line : int;
  column : int;
  offset : int;
}

(** The initial location for a file. *)
val initial : string -> t

(** Advance to the next column. *)
val next_column : t -> t

(** Advance to the beginning of the next line. *)
val next_line : t -> t

(** Convert a location to a human-readable string. *)
val to_string : t -> string