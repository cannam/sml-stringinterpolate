SCRIPTS	:= ../sml-buildscripts

test:	test.mlb string-interpolate.mlb test.deps
	${SCRIPTS}/polybuild test.mlb
	./test

test.deps: test.mlb string-interpolate.mlb
	${SCRIPTS}/mlb-dependencies $^ > $@

clean:
	rm -f test *.deps

-include *.deps
