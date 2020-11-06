
signature STRING_BUFFER = sig

    type buffer

    val new : unit -> buffer
    val appendTo : buffer * string -> unit
    val toString : buffer -> string
                                 
end
