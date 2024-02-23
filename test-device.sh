#!/bin/sh
[ -z "$MQTT_USER" ] && MQTT_USER=user;
[ -z "$MQTT_PASS" ] && MQTT_PASS=pass;
[ -z "$MQTT_HOST" ] && MQTT_HOST=localhost;
[ -z "$MQTT_PORT" ] && MQTT_PORT=1883;
[ -z "$MQTT_BASE" ] && MQTT_BASE="owntracks/$MQTT_USER/simulator1";
[ -z "$MQTT_FRIEND" ] && MQTT_BASE="owntracks/$MQTT_USER/simulator2";

CMD="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_BASE/cmd -q 1"
PUB="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_BASE -r -q 1"
PUBINFO="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_BASE/info -r -q 1"
FRIPUB="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND -r -q 1"
FRIEVENT="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND/event -q 1"
FRIINFO="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND/info -r -q 1"

echo $CMD

echo "Running OwnTracks cmd tests against an OwnTracks device"
echo "You may want to follow the results by mosquitto_sub -t '#' | jq"

$CMD -f test/array-empty.json
$CMD -f test/object-empty.json
$CMD -f test/cmd-illegal-action.json
$CMD -f test/cmd-without-action.json

$CMD -f test/cmd-status.json
$CMD -f test/cmd-dump.json
$CMD -f test/cmd-reportLocation.json

# you may not get an immediate response because the device prompts the user for access to fitness data
$CMD -f test/cmd-reportSteps.json

$CMD -f test/cmd-waypoints.json
$CMD -f test/cmd-clearWaypoints.json
$CMD -f test/cmd-waypoints.json
$CMD -f test/cmd-setWaypoints.json
$CMD -f test/cmd-waypoints.json

$PUBINFO -f test/card-without-face.json
$PUBINFO -f test/card-vw.json

$FRIINFO -f test/card-volvo.json
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=0 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=-1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 tid=S1 m=1 cog=56`

exit

