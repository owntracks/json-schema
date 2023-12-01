.PHONY: test
CHECK=check-jsonschema
CHECKFLAGS=-v
PWD=`pwd`

test:meta examples 
	@echo

meta: schemas/encryption.meta schemas/messages.meta schemas/message.meta

%.meta: %.json
	$(CHECK) $(CHECKFLAGS) --check-metaschema $?

examples:
	@$(MAKE) -C test

