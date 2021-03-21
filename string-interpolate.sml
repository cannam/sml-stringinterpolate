structure StringInterpolate : STRING_INTERPOLATE = struct

    fun objection complaint str =
        let val text = "StringInterpolate: WARNING: " ^ complaint ^
                       " in string interpolation for \"" ^ str ^ "\"\n"
        in
            TextIO.output (TextIO.stdErr, text)
        end

    (*!!! this message is, ironically, currently unused *)
(*    val unusedValues : string -> unit = objection "Unused values" *)
                                 
    val absentValue : string -> unit = objection "Too few values"
    val nonNumericIndex : string -> unit = objection "Numeric index missing"
                                
    fun interpolate_n_maybe (template, n_maybe, arglist) =
        let val args = Vector.fromList arglist
            fun arg cn =
                if Char.isDigit cn andalso cn <> #"0"
                then let val ix = (Char.ord cn - Char.ord #"1")
                     in if Vector.length args > ix
                        then String.explode (Vector.sub (args, ix))
                        else (absentValue template; [#"%", cn])
                     end
                else if cn = #"n"
                then case n_maybe of
                         NONE => (nonNumericIndex template; [#"%", cn])
                       | SOME n => String.explode (Int.toString n)
                else (nonNumericIndex template; [#"%", cn])
            fun interp acc chars =
                case chars of
                    #"%":: #"%"::rest => interp (#"%"::acc) rest
                  | #"%"::cn::rest => interp ((rev (arg cn)) @ acc) rest
                  | first::rest => interp (first::acc) rest
                  | [] => String.implode (rev acc)
        in
            interp [] (String.explode template)
        end
                             
    fun interpolate message values =
        interpolate_n_maybe (message, NONE, values)

    fun interpolate_n message (n, values) =
        interpolate_n_maybe (message, SOME n, values)

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
                                                       
