
local
    open StringInterpolate
    val testcases = [
        ("empty", "", [], [""]),
        ("verbatim", "abc", [], ["abc"]),
        ("char", "a%c", [C #"b"], ["abc"]),
        ("string", "a%c", [S "b"], ["abc"]),
        ("string-2", "a%", [S "bc"], ["abc"]),
        ("string-3", "%c", [S "ab"], ["abc"]),
        ("string-only", "%", [S "abc"], ["abc"]),
        ("string+char", "%%", [S "ab", C #"c"], ["abc"]),
        ("empty-string-in-middle", "%%%", [S "ab", S "", C #"c"], ["abc"]),
        ("int", "%", [I 4], ["4"]),
        ("negative-int", "%", [I ~4], ["-4"]),
        ("real-zero", "%", [R 0.0], ["0.0", "0"]),
        ("real-one", "%", [R 1.0], ["1.0", "1"]),
        ("real-noninteger", "%", [R 1.2], ["1.2"]),
        ("real-small", "%", [R 1.0e~14], ["1E-14","1e-14"]),
        ("real-large", "%", [R 1.0e14], ["1E14","1e+14"]),
        ("real-inf", "%", [R Real.posInf], ["inf"]),
        ("real-negative-inf", "%", [R Real.negInf], ["-inf"]),
        ("real-nan", "%", [R (Real.posInf + Real.negInf)], ["nan","-nan"]),
        ("real-negative-one", "%", [R ~1.0], ["-1.0", "-1"]),
        ("real-negative-small", "%", [R ~1.0e~14], ["-1E-14","-1e-14"]),
        ("real-negative-large", "%", [R ~1.0e14], ["-1E14","-1e+14"]),
        ("number-zero", "%", [N 0.0], ["0"]),
        ("number-one", "%", [N 1.0], ["1"]),
        ("number-noninteger", "%", [N 1.2], ["1.2"]),
        ("number-small", "%", [N 1.0e~14], ["1E-14","1e-14"]),
        ("number-large", "%", [N 1.0e14], ["1E14","1e+14"]),
        ("number-inf", "%", [N Real.posInf], ["inf"]),
        ("number-negative-inf", "%", [N Real.negInf], ["-inf"]),
        ("number-nan", "%", [N (Real.posInf + Real.negInf)], ["nan","-nan"]),
        ("number-negative-one", "%", [N ~1.0], ["-1"]),
        ("number-negative-small", "%", [N ~1.0e~14], ["-1E-14","-1e-14"]),
        ("number-negative-within", "%", [N ~1.0e6], ["-1000000"]),
        ("number-negative-without", "%", [N ~1.0e7], ["-1E7", "-1E07", "-1e+07", "-1e+7"]),
        ("number-negative-large", "%", [N ~1.0e14], ["-1E14","-1e+14"]),
        ("bool-true", "%", [B true], ["true"]),
        ("bool-false", "%", [B false], ["false"]),
        ("stringlist", "%", [SL ["a", "b", "c"]], ["a\nb\nc"]),
        ("realvector", "%", [RV (RealVector.fromList [~1.0, 0.0, 1.2])], ["-1.0,0.0,1.2", "-1,0,1.2"]),
        ("realarray", "%", [RA (RealArray.fromList [~1.0, 0.0, 1.2])], ["-1.0,0.0,1.2","-1,0,1.2"]),
        ("numbervector", "%", [NV (RealVector.fromList [~1.0, 0.0, 1.2])], ["-1,0,1.2"]),
        ("numberarray", "%", [NA (RealArray.fromList [~1.0, 0.0, 1.2])], ["-1,0,1.2"]),
        ("time", "%", [T (Time.fromMilliseconds 12345)], ["12.345"]),
        ("int-in-middle", "The %th storey", [I 4], ["The 4th storey"]),
        ("escape-percent-start", "\\%%", [S "a"], ["%a"]),
        ("escape-percent-middle-1", "q\\%%", [S "a"], ["q%a"]),
        ("escape-percent-middle-2", "%\\%%", [S "a", S "b"], ["a%b"]),
        ("escape-percent-end", "%\\%", [S "a"], ["a%"]),
        ("escape-escape", "\\\\%%", [S "a", S "b"], ["\\ab"]),
        ("escape-other", "%\\%\\e%%\\%", [S "ab", S "c", S "d"], ["ab%\\ecd%"])
    ]
in
    val string_interpolate_tests =
        map (fn (name, str, values, expected) =>
                (name, fn () => 
                          let val obtained = interpolate str values
                          in
                              if List.exists (fn e => obtained = e) expected
                              then true
                              else (print ("--- Test \"" ^ name ^
                                           "\" failed:\n--- Expected " ^
                                           (String.concatWith " or " expected) ^
                                           "\n--- Obtained " ^ obtained ^ "\n");
                                    false)
                          end)) testcases
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

                   
