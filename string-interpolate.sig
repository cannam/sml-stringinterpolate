
signature STRING_INTERPOLATE = sig

    (** Interpolate arguments into a format string. The first argument
        is the format string and the rest are arguments to be
        interpolated.

        Each occurrence in the format string of the character %
        followed by a single digit is replaced by the correspondingly
        indexed item in the remaining strings (counting from 1).

        For a literal %, use %%.
    *)
    val interpolate : string -> string list -> string

    (** Interpolate arguments into a format string, including a
        special numeric argument which is treated separately. The
        first argument is the format string and the rest are the
        special numeric argument and the remaining arguments to be
        interpolated.

        Each occurrence in the format string of the character %
        followed by the character n is replaced by the numeric
        argument as a decimal integer.

        Each occurrence in the format string of the character %
        followed by a single digit is replaced by the correspondingly
        indexed item in the remaining strings (counting from 1).

        For a literal %, use %%.
    *)
    val interpolate_n : string -> int * string list -> string

    (*  The rest of these functions are data-to-string conversion
        shorthands for use when creating the argument string list.
     *)
    val I : int -> string
    val FI : FixedInt.int -> string
    val R : real -> string
    val R32 : Real32.real -> string
    val N : real -> string
    val Z : real * real -> string
    val C : char -> string
    val B : bool -> string
    val S : string -> string
    val SL : string list -> string
    val SV : string vector -> string
    val RV : RealVector.vector -> string
    val RA : RealArray.array -> string
    val NV : RealVector.vector -> string
    val NA : RealArray.array -> string
    val T : Time.time -> string
    val O : string option -> string
    val X : exn -> string

end
        
