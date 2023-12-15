.PHONY: test
CHECK=check-jsonschema
CHECKFLAGS=-v
PWD=`pwd`

test:messagestest encryptiontest messagetest
	@echo

messagestest: array.ssuccess array-one.ssuccess array-empty.ssuccess one.ssuccess #array-nothing.ssuccess

encryptiontest: e.esuccess e-nodata.efail e-nobase64.efail

messagetest: card-without-face.mfail \
	cmd-illegal-action.mfail \
	cmd-without-action.mfail \
	cmd-action-wo-content.mfail \
	untour-illegal.mfail \
	steps-kaputt.mfail \
	location-lat-missing.mfail \
	tour-invalid-request.mfail \
	transition-illegal-lat.mfail \
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
	steps-long-invalid.mfail \
	steps-nohave.msuccess \
	transition.msuccess \
	w.msuccess \
	waypoint-circular.msuccess \
	lwt.msuccess \
	lwt-notst.mfail \
	lwt-extra.msuccess

%.esuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/encryption.json --base-uri $(PWD)/../schemas/encryption.json $?

%.efail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/encryption.json --base-uri $(PWD)/../schemas/encryption.json $?

%.ssuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/messages.json --base-uri $(PWD)/../schemas/messages.json $?

%.sfail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/messages.json --base-uri $(PWD)/../schemas/messages.json $?

%.msuccess: %.json
	@$(CHECK) $(CHECKFLAGS) --schemafile ../schemas/message.json --base-uri $(PWD)/../schemas/message.json $?

%.mfail: %.json
	@! $(CHECK) $(CHECKFLAGS) --schemafile ../schemas/message.json --base-uri $(PWD)/../schemas/message.json $?

