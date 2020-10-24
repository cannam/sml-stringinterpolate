
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
            ("%", [I ~4], "-4"),
            ("%", [R 0.0], "0.0"),
            ("%", [R 1.0], "1.0"),
            ("%", [R 1.2], "1.2"),
            ("%", [R Real.posInf], "inf"),
            ("%", [R Real.negInf], "-inf"),
            ("%", [R (Real.posInf + Real.negInf)], "nan"),
            ("%", [R ~1.0], "-1.0"),
            ("%", [R ~1.0e~14], "-1.0e-14"),
            ("%", [N 0.0], "0"),
            ("%", [N 1.0], "1"),
            ("%", [N 1.2], "1.2"),
            ("%", [N Real.posInf], "inf"),
            ("%", [N Real.negInf], "-inf"),
            ("%", [N (Real.posInf + Real.negInf)], "nan"),
            ("%", [N ~1.0], "-1"),
            ("%", [N ~1.0e~14], "-1.0e-14"),
            ("%", [B true], "true"),
            ("%", [B false], "false"),
            ("%", [SL ["a", "b", "c"]], "a\nb\nc"),
            ("%", [RV (RealVector.fromList [~1.0, 0.0, 1.2])], "[-1.0,0.0,1.2]"),
            ("%", [RA (RealArray.fromList [~1.0, 0.0, 1.2])], "[-1.0,0.0,1.2]"),
            ("%", [NV (RealVector.fromList [~1.0, 0.0, 1.2])], "[-1,0,1.2]"),
            ("%", [NA (RealArray.fromList [~1.0, 0.0, 1.2])], "[-1,0,1.2]"),
            ("%", [T (Time.fromMilliseconds 12345)], "12.345"),
            ("The %th storey", [I 4], "The 4th storey"),
            ("\\%%", [S "a"], "%a"),
            ("\\\\%%", [S "a", S "b"], "\\ab"),
            ("%\\%\\e%%\\%", [S "ab", S "c", S "d"], "ab%ecd%")
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
                   
