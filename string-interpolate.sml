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
            fun checkAndSnipEndingEscape (s : string) =
                let fun ends' (s, ~1) = false
                      | ends' (s, ix) =
                        case sub (s, ix) of
                            #"\\" => not (ends' (s, ix-1))
                          | _ => false
                in
                    if ends' (s, size s - 1)
                    then (true, substring (s, 0, size s - 1))
                    else if s <> "" andalso sub (s, size s - 1) = #"\\"
                    then (false, substring (s, 0, size s - 1))
                    else (false, s)
                end
            val ff = fields (fn c => c = #"%") message
            val first = hd ff
            val rest = tl ff
            fun folder (s, (escaping, values, acc)) =
                let val (e, s') = checkAndSnipEndingEscape s
                in
                    case (values, escaping) of
                        (_, true) => (e, values, s' :: "%" :: acc)
                      | (x::xs, false) => (e, xs, s' :: x :: acc)
                      | ([], false) => (tooFewValues message;
                                        (e, values, s' :: acc))
                end
            val (e, s') = checkAndSnipEndingEscape first
        in
            case foldl folder (e, values, [s']) rest of
                (escaping, values, acc) =>
                let val result = concat (List.rev acc)
                in
                    case (escaping, values) of
                        (false, []) => result
                      | (true, []) => (looseEscape message; result)
                      | (_, values) => (tooManyValues message; result)
                end
        end

    val C = String.str
    fun B b = if b then "true" else "false"
    fun S s = s
    val SL = String.concatWith "\n"
    val X = exnMessage

    fun replaceNegative s =
        implode (map (fn #"~" => #"-" | c => c) (explode s))
                
    fun I i =
        if i < 0
        then case Int.minInt of
                 NONE => "-" ^ I (~i)
               | SOME min =>
                 (* assume two's complement, so ~min can't be represented *)
                 if i > min
                 then "-" ^ I (~i)
                 else replaceNegative (Int.toString i)
        else Int.toString i
                
    fun FI i =
        if i < 0
        then case FixedInt.minInt of
                 NONE => "-" ^ FI (~i)
               | SOME min =>
                 (* assume two's complement, so ~min can't be represented *)
                 if i > min
                 then "-" ^ FI (~i)
                 else replaceNegative (FixedInt.toString i)
        else FixedInt.toString i

    fun R r =
        String.map (fn #"~" => #"-" | c => c)
                   (Real.fmt (StringCvt.GEN (SOME 6)) r)

    fun R32 r =
        String.map (fn #"~" => #"-" | c => c)
                   (Real32.fmt (StringCvt.GEN (SOME 6)) r)

    (* If we change any of the following, we'll need to change
       string-interpolate-ffi as well: *)
                   
    fun N n =
        if Real.isFinite n andalso
           Real.== (n, Real.realRound n) andalso
           Real.<= (Real.abs n, 1e6)
        then I (Real.round n)
        else R n

    fun Z (re, im) =
        if im < 0.0
        then R re ^ " - " ^ R (~im)
        else R re ^ " + " ^ R im
               
    fun RV v =
        let fun toList v = RealVector.foldr (op::) [] v
        in String.concatWith "," (map R (toList v))
        end

    fun RA a = RV (RealArray.vector a)

    fun NV v =
        let fun toList v = RealVector.foldr (op::) [] v
        in String.concatWith "," (map N (toList v))
        end

    fun NA a = NV (RealArray.vector a)

    fun O NONE = "*none*"
      | O (SOME s) = s

    val T = R o Time.toReal

end
                                                       
