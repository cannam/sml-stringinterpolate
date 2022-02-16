
local
    open StringInterpolate
    val testcases = [
        ("empty", "", [], [""]),
        ("verbatim", "abc", [], ["abc"]),
        ("char", "a%1c", [C #"b"], ["abc"]),
        ("string", "a%1c", [S "b"], ["abc"]),
        ("string-2", "a%1", [S "bc"], ["abc"]),
        ("string-3", "%1c", [S "ab"], ["abc"]),
        ("string-only", "%1", [S "abc"], ["abc"]),
        ("string+char", "%1%2", [S "ab", C #"c"], ["abc"]),
        ("empty-string-in-middle", "%1%2%3", [S "ab", S "", C #"c"], ["abc"]),
        ("int", "%1", [I 4], ["4"]),
        ("negative-int", "%1", [I ~4], ["-4"]),
        ("real-zero", "%1", [R 0.0], ["0.0", "0"]),
        ("real-one", "%1", [R 1.0], ["1.0", "1"]),
        ("real-noninteger", "%1", [R 1.2], ["1.2"]),
        ("real-small", "%1", [R 1.0e~14], ["1E-14","1e-14"]),
        ("real-large", "%1", [R 1.0e14], ["1E14","1e+14"]),
        ("real-inf", "%1", [R Real.posInf], ["inf"]),
        ("real-negative-inf", "%1", [R Real.negInf], ["-inf"]),
        ("real-nan", "%1", [R (Real.posInf + Real.negInf)], ["nan","-nan"]),
        ("real-negative-one", "%1", [R ~1.0], ["-1.0", "-1"]),
        ("real-negative-small", "%1", [R ~1.0e~14], ["-1E-14","-1e-14"]),
        ("real-negative-large", "%1", [R ~1.0e14], ["-1E14","-1e+14"]),
        ("number-zero", "%1", [N 0.0], ["0"]),
        ("number-one", "%1", [N 1.0], ["1"]),
        ("number-noninteger", "%1", [N 1.2], ["1.2"]),
        ("number-small", "%1", [N 1.0e~14], ["1E-14","1e-14"]),
        ("number-large", "%1", [N 1.0e14], ["1E14","1e+14"]),
        ("number-inf", "%1", [N Real.posInf], ["inf"]),
        ("number-negative-inf", "%1", [N Real.negInf], ["-inf"]),
        ("number-nan", "%1", [N (Real.posInf + Real.negInf)], ["nan","-nan"]),
        ("number-negative-one", "%1", [N ~1.0], ["-1"]),
        ("number-negative-small", "%1", [N ~1.0e~14], ["-1E-14","-1e-14"]),
        ("number-negative-within", "%1", [N ~1.0e6], ["-1000000"]),
        ("number-negative-without", "%1", [N ~1.0e7], ["-1E7", "-1E07", "-1e+07", "-1e+7"]),
        ("number-negative-large", "%1", [N ~1.0e14], ["-1E14","-1e+14"]),
        ("bool-true", "%1", [B true], ["true"]),
        ("bool-false", "%1", [B false], ["false"]),
        ("stringlist", "%1", [SL ["a", "b", "c"]], ["[a, b, c]"]),
        ("realvector", "%1", [RV (RealVector.fromList [~1.0, 0.0, 1.2])], ["-1.0,0.0,1.2", "-1,0,1.2"]),
        ("realarray", "%1", [RA (RealArray.fromList [~1.0, 0.0, 1.2])], ["-1.0,0.0,1.2","-1,0,1.2"]),
        ("numbervector", "%1", [NV (RealVector.fromList [~1.0, 0.0, 1.2])], ["-1,0,1.2"]),
        ("numberarray", "%1", [NA (RealArray.fromList [~1.0, 0.0, 1.2])], ["-1,0,1.2"]),
        ("time", "%1", [T (Time.fromMilliseconds 12345)], ["12.345"]),
        ("int-in-middle", "The %1th storey", [I 4], ["The 4th storey"]),
        ("escape-only", "%%", [S "a"], ["%"]),
        ("escape-start", "%%%1", [S "a"], ["%a"]),
        ("escape-middle-1", "q%%%1", [S "a"], ["q%a"]),
        ("escape-middle-2", "%1%%%2", [S "a", S "b"], ["a%b"]),
        ("escape-end", "%1%%", [S "a"], ["a%"]),
        ("loose-end", "%1%", [S "a"], ["a%"]),
        ("out-of-order-2", "%2%1", [S "a", S "b"], ["ba"]),
        ("out-of-order-3", "%2%3%1", [S "a", S "b", S "c"], ["bca"]),
        ("repeated", "%2%3%3%1", [S "a", S "b", S "c"], ["bcca"])
    ]
    fun failure name obtained expected =
        (print ("--- Test \"" ^ name ^
                "\" failed:\n--- Expected " ^
                (String.concatWith " or " expected) ^
                "\n--- Obtained " ^ obtained ^ "\n");
         false)
in
    val string_interpolate_tests =
        map (fn (name, str, values, expected) =>
                (name, fn () => 
                          let val obtained = interpolate str values
                          in
                              if List.exists (fn e => obtained = e) expected
                              then true
                              else failure name obtained expected
                          end)) testcases
        @
        [ ("n", fn () =>
                   let val obtained = interpolate_n "%1%n%2" (4, [I 1, I 2])
                       val expected = "142"
                   in
                       if obtained = expected
                       then true
                       else failure "n" obtained [expected]
                   end)
        ]
end

fun main () =
    let val result =
            foldl (fn ((name, test), success) =>
                      if test ()
                      then success
                      else false)
                  true
                  string_interpolate_tests
    in
        if result
        then print "All tests passed\n"
        else print "Some tests failed\n"
    end

                   
