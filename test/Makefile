.PHONY: test
CHECK=check-jsonschema
CHECKFLAGS=-v
PWD=`pwd`

test:messagestest encryptiontest messagetest
	@echo

messagestest: array.ssuccess array-one.ssuccess array-empty.ssuccess #array-nothing.ssuccess

encryptiontest: e.esuccess e-nodata.efail e-nobase64.efail

messagetest: card-without-face.mfail \
	cmd-illegal-action.mfail \
	cmd-without-action.mfail \
	cmd-action-wo-content.mfail \
	untour-illegal.mfail \
	steps-kaputt.mfail \
	location-lat-missing.mfail \
	tour-invalid-request.mfail \
	card.msuccess \
	cmd3.msuccess \
	cmd5.msuccess \
	l.msuccess \
	l2.msuccess \
	location-5s.msuccess \
	location-short.msuccess \
	location-sk.msuccess \
	tour.msuccess \
	tours-request.msuccess \
	tours-response-0.msuccess \
	tours-response-2.msuccess \
	untour.msuccess \
	steps.msuccess \
	steps-long.msuccess \
	steps-nohave.msuccess \
	transition.msuccess \
	w.msuccess \
	waypoint-circular.msuccess

%.esuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/encryption --base-uri $(PWD)/../schemas/encryption $?

%.efail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/encryption --base-uri $(PWD)/../schemas/encryption $?

%.ssuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/messages --base-uri $(PWD)/../schemas/messages $?

%.sfail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/messages --base-uri $(PWD)/../schemas/messages $?

%.msuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/message --base-uri $(PWD)/../schemas/message $?

%.mfail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/message --base-uri $(PWD)/../schemas/message $?

