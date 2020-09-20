signature STRING_INTERPOLATE = sig

    (* The first argument is the format string and the rest are
       arguments to be interpolated. The format string must contain a
       % character for each of the remaining strings, which will be
       interpolated to replace the % characters in turn.
    *)
    val interpolate : string -> string list -> string

    (* Data-to-string conversion shorthands: *)
    val I : int -> string
    val R : real -> string
    val C : char -> string
    val B : bool -> string
    val S : string -> string
    val SL : string list -> string
    val RV : real vector -> string
    val RA : real array -> string
    val T : Time.time -> string
    val X : exn -> string

end
        
