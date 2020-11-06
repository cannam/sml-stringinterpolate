
structure StringBuffer :> STRING_BUFFER = struct

    fun ensureSize (buffer, fill) toAdd =
        let fun doubleBeyond m n = if n > m then n else doubleBeyond m (n * 2)
            val oldLen = CharArray.length buffer
            val newLen = doubleBeyond (fill + toAdd) oldLen
        in
            if oldLen = newLen
            then buffer
            else let val newBuf = CharArray.array (newLen, Char.chr 0)
                     val _ = CharArray.copy { src = buffer, dst = newBuf, di = 0 }
                 in newBuf
                 end
        end

    type buffer = { 
        buffer : CharArray.array ref,
        fill : int ref
    }

    val initialSize = 4096
                         
    fun new () = {
        buffer = ref (CharArray.array (initialSize, Char.chr 0)),
        fill = ref 0
    }
            
    fun appendTo ({ buffer, fill }, s) =
        let val stringLen = String.size s
            val newBuf = ensureSize (!buffer, !fill) stringLen
            val _ = CharArray.copyVec { src = s, dst = newBuf, di = !fill }
        in
            buffer := newBuf;
            fill := !fill + stringLen
        end

    fun toString { buffer, fill } =
        CharArraySlice.vector (CharArraySlice.slice (!buffer, 0, SOME (!fill)))

end
