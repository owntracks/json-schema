# OwnTracks JSON Schema

- messages allows a single message or an array of messages of type message (used in iOS app on the HTTP receive end)
- encryption is used to check the message if application level encryption is enabled
- message has all OwnTracks messages

in ./test there is a Makefile to perform validations on a number of test cases using [check-jsonschema](https://check-jsonschema.readthedocs.io/en/latest/)

## iOS implementation

iOS uses [DSJSONSchemaValidation](https://github.com/dashpay/JSONSchemaValidation) to validate all incoming messages
integrated using Cocoapods.

## Android implementation

## Recorder implementation
