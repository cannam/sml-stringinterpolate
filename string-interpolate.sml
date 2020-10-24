structure StringInterpolate : STRING_INTERPOLATE = struct

    fun tooManyValues str =
        TextIO.output
            (TextIO.stdErr,
             "StringInterpolate: WARNING: Too many values in string interpolation for \"" ^
             str ^ "\"\n")

    fun tooFewValues str =
        TextIO.output
            (TextIO.stdErr,
             "StringInterpolate: WARNING: Too few values in string interpolation for \"" ^
             str ^ "\"\n")

    fun looseEscape str =
        TextIO.output
            (TextIO.stdErr,
             "StringInterpolate: WARNING: Spare escape character at end of string in \"" ^
             str ^ "\"\n")

    fun interpolate message values =
        let open String
            fun endsInEscape (s : string) =
                let fun ends' (s, ~1) = false
                      | ends' (s, ix) =
                        case sub (s, ix) of
                            #"\\" => not (ends' (s, ix-1))
                          | _ => false
                in
                    ends' (s, size s - 1)
                end
            val ff = fields (fn c => c = #"%") message
            val first = hd ff
            val rest = tl ff
        in
            case foldl (fn (s, (escaping, values, acc)) =>
                           let val e = endsInEscape s
                           in
                               case (values, escaping) of
                                   (_, true) =>
                                   (e, values, s::acc)
                                 | ([], false) => 
                                   (tooFewValues message; (e, values, s::acc))
                                 | (x::xs, false) => 
                                   (e, xs,
                                    (if e
                                     then substring (s, 0, size s - 1)
                                     else s)
                                    ::x::acc)
                           end)
                       (endsInEscape first, values, [first])
                       rest of
                (escaping, values, acc) =>
                let val result = concat (List.rev acc)
                in
                    case (escaping, values) of
                        (false, []) => result
                      | (true, []) => (looseEscape message; result)
                      | (_, values) => (tooManyValues message; result)
                end
        end
(*            
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
*)
    fun I i =
        if i < 0
        then "-" ^ I (~i)
        else Int.toString i

    fun R r =
        String.map (fn #"~" => #"-" | c => c)
                   (Real.fmt (StringCvt.GEN (SOME 6)) r)

    fun N n =
        if Real.isFinite n andalso Real.== (n, Real.realRound n)
        then I (Real.round n)
        else R n
                   
    val C = String.str
    fun B b = if b then "true" else "false"
    fun S s = s
    val SL = String.concatWith "\n"
    fun RV v =
        let fun toList v = rev (RealVector.foldl (op::) [] v)
        in "[" ^ (String.concatWith "," (map R (toList v))) ^ "]"
        end
    fun RA a = RV (RealArray.vector a)
    fun NV v =
        let fun toList v = rev (RealVector.foldl (op::) [] v)
        in "[" ^ (String.concatWith "," (map N (toList v))) ^ "]"
        end
    fun NA a = NV (RealArray.vector a)
    val T = R o Time.toReal
    val X = exnMessage
            
end
                                                       
