all:
	@dune build

doc:
	@dune build @doc

test:
	@dune build @runtest
	@dune build @citest

.PHONY: test
