#!/bin/sh
for j in e.json
do
	echo $j
	check-jsonschema -v --schemafile ../schemas/encryption.json $j;
	echo $?
done
for j in array.json \
	array-empty.json \
	array-one.json \
	#array-nothing.json
do
	echo $j
	#check-jsonschema -v --schemafile ../schemas/messages.json $j;
	check-jsonschema -v --schemafile ../schemas/messages-standalone.json $j;
	echo $?
done
for j in card-without-face.json \
	cmd-illegal-action.json \
	cmd-without-action.json \
	cmd-action-wo-content.json \
	untour-illegal.json \
	steps-kaputt.json \
	location-lat-missing.json \
	tour-invalid-request.json 
do
	echo $j
	check-jsonschema -v --schemafile ../schemas/message.json $j;
	echo $?
done
for j in card.json \
	cmd3.json \
	cmd5.json \
	l.json \
	l2.json \
	location-5s.json \
	location-short.json \
	location-sk.json \
	tour.json \
	tours-request.json \
	tours-response-0.json \
	tours-response-2.json \
	untour.json \
	steps.json \
	steps-long.json \
	steps-nohave.json \
	transition.json \
	w.json \
	waypoint-circular.json
do
	echo $j
	check-jsonschema -v --schemafile ../schemas/message.json $j;
	echo $?
done
