
structure StringInterpolate : STRING_INTERPOLATE = struct

    (* Redefine the existing structure, using some FFI calls *)

    open StringInterpolate

    val strfromd =
        _import "strfromd" public: CharArray.array * Int64.int * string * real -> Int32.int;

    val format = "%.6lg" ^ String.str (Char.chr 0)
    val format2 = ">>> %f <<<\n" ^ String.str (Char.chr 0)
    
    fun R (r : real) =
        let val bufsize = 32
            val buffer = CharArray.array (bufsize, Char.chr 0)
            val produced = Int32.toInt (strfromd (buffer,
                                                  Int64.fromInt bufsize,
                                                  format,
                                                  r))
        in
            if produced > bufsize
            then raise Subscript
            else CharArraySlice.vector
                     (CharArraySlice.slice (buffer, 0, SOME produced))
        end

    (* We also need to reimplement the functions that call R: *)
            
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

    val T = R o Time.toReal

end
                                                       
