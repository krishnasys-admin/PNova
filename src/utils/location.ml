type t = {
  filename : string;
  line : int;
  column : int;
  offset : int;
}

let initial filename =
  {
    filename;
    line = 1;
    column = 1;
    offset = 0;
  }

let next_column loc =
  { loc with column = loc.column + 1; offset = loc.offset + 1 }

let next_line loc =
  {
    loc with
    line = loc.line + 1;
    column = 1;
    offset = loc.offset + 1;
  }

let to_string loc =
  Printf.sprintf "%s:%d:%d"
    loc.filename
    loc.line
    loc.column