module IdentifierOrd = struct
  type t = Identifier.t

  let compare = Identifier.compare
end

include Set.Make (IdentifierOrd)