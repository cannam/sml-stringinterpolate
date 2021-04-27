
structure StringInterpolate : STRING_INTERPOLATE = struct

    (* Redefine the existing structure, using some FFI calls *)

    open StringInterpolate

    val string_from_real =
        _import "string_from_double" public: CharArray.array * Int64.int * real -> Int32.int;

    val string_from_real32 =
        _import "string_from_float" public: CharArray.array * Int64.int * Real32.real -> Int32.int;

    val string_from_int64 =
        _import "string_from_int64" public: CharArray.array * Int64.int * Int64.int -> Int32.int;

    val format = "%.6lg" ^ String.str (Char.chr 0)
    
    fun R (r : real) =
        let val bufsize = 32
            val buffer = CharArray.array (bufsize, Char.chr 0)
            val produced = Int32.toInt (string_from_real
                                            (buffer,
                                             Int64.fromInt bufsize,
                                             r))
        in
            if produced > bufsize
            then raise Subscript
            else CharArraySlice.vector
                     (CharArraySlice.slice (buffer, 0, SOME produced))
        end
    
    fun R32 (r : Real32.real) =
        let val bufsize = 32
            val buffer = CharArray.array (bufsize, Char.chr 0)
            val produced = Int32.toInt (string_from_real32
                                            (buffer,
                                             Int64.fromInt bufsize,
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
                                                       
