
fun test () =
    let open StringInterpolate
        val testcases = [
            ("", [], ""),
            ("abc", [], "abc"),
            ("a%c", [C #"b"], "abc"),
            ("a%c", [S "b"], "abc"),
            ("a%", [S "bc"], "abc"),
            ("%c", [S "ab"], "abc"),
            ("%", [S "abc"], "abc"),
            ("%%", [S "ab", C #"c"], "abc"),
            ("%%%", [S "ab", S "", C #"c"], "abc"),
            ("%", [I 4], "4"),
            ("The %th storey", [I 4], "The 4th storey")
                (* etc *)
        ]
        val (result, _) =
            foldl (fn ((str, values, expected), (success, n)) =>
                      let val obtained = interpolate str values
                      in
                          if obtained = expected
                          then (success, n+1)
                          else (print ("--- Test " ^ Int.toString n ^
                                       " failed:\n--- Expected " ^ expected
                                       ^ "\n--- Obtained " ^ obtained ^ "\n");
                                (false, n+1))
                      end)
                  (true, 1)
                  testcases
    in
        if result
        then print "All tests passed\n"
        else print "Some tests failed\n"
    end

fun main () = test ()
                   
