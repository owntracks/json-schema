.PHONY: test
CHECK=check-jsonschema
CHECKFLAGS=-v
PWD=`pwd`

test:meta examples 
	@echo

meta: schemas/*
	$(CHECK) $(CHECKFLAGS) --check-metaschema $?

examples:
	@$(MAKE) -C test

