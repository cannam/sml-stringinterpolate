SCRIPTS	:= ../sml-buildscripts

test:	test.mlb string-interpolate.mlb test.deps
	${SCRIPTS}/polybuild $<
	./test

test-ffi: test-ffi.mlb string-interpolate.mlb test-ffi.deps
	mlton  -default-ann 'allowFFI true' -default-ann 'allowPrim true' $<
	./test-ffi

%.deps: %.mlb string-interpolate.mlb
	${SCRIPTS}/mlb-dependencies $^ > $@

clean:
	rm -f test *.deps

-include *.deps
