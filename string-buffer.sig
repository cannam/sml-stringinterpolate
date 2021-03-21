
(** A mutable buffer type to which a series of strings can be written,
    and the concatenation of them then retrieved. Allocates in a
    sensible way, making this faster than repeated use of the string
    concatenation operator ^ and potentially using space more
    effectively than listing all the strings and calling
    String.concat.  (The latter remains to be tested - if it turns out
    not to be true, we can replace the implementation with that!)
*)

signature STRING_BUFFER = sig

    type buffer

    (** Create an empty string buffer *)
    val new : unit -> buffer

    (** Append a string to the content of the mutable buffer *)
    val appendTo : buffer * string -> unit

    (** Return the content of the buffer, i.e. the concatenation of
        all strings so far appended to it in order. *)
    val toString : buffer -> string
                                 
end
