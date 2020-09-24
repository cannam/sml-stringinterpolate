structure StringInterpolate : STRING_INTERPOLATE = struct

    fun tooManyValues str =
        TextIO.output
            (TextIO.stdErr,
             "StringInterpolate: WARNING: Too many values in string interpolation for \"" ^
             str ^ "\"\n")
            
    fun interpolate str values =
        let fun intAux acc chars [] _ = String.implode (rev acc @ chars)
              | intAux acc [] _ _ = (tooManyValues str; intAux acc [] [] false)
              | intAux acc (first::rest) values escaped =
                if first = #"\\" then
                    intAux acc rest values (not escaped)
                else if first = #"%" andalso not escaped then
                    intAux ((rev (String.explode (hd values))) @ acc)
                            rest (tl values) escaped
                else
                    intAux (first::acc) rest values false
        in
            intAux [] (String.explode str) values false
        end

    val I = Int.toString

    fun R r =
        if r < 0.0
        then "-" ^ R (~r)
        else Real.fmt (StringCvt.GEN (SOME 6)) r

    val C = String.str
    fun B b = if b then "true" else "false"
    fun S s = s
    val SL = String.concatWith "\n"
    fun RV v =
        let fun toList v = rev (Vector.foldl (op::) [] v)
        in "[" ^ (String.concatWith "," (map R (toList v))) ^ "]"
        end
    fun RA a = RV (Array.vector a)
    val T = R o Time.toReal
    val X = exnMessage
            
end
                                                       
