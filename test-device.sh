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

echo
echo "Testing some corrupt or illegal messages..."
$CMD -f test/array-empty.json
$CMD -f test/object-empty.json
$CMD -f test/cmd-illegal-action.json
$CMD -f test/cmd-without-action.json

echo "Testing status..."
$CMD -f test/cmd-status.json
echo "Testing dump..."
$CMD -f test/cmd-dump.json
echo "Testing reportLocation..."
$CMD -f test/cmd-reportLocation.json

echo "Testing reportSteps... you may not get an immediate response because the device prompts the user for access to fitness data"
$CMD -f test/cmd-reportSteps.json

echo "Testing waypoints..."
$CMD -f test/cmd-waypoints.json
echo "Testing clearWaypoints..."
$CMD -f test/cmd-clearWaypoints.json
$CMD -f test/cmd-waypoints.json
echo "Testing setWaypoints...(insert)"
$CMD -f test/cmd-setWaypoints.json
$CMD -f test/cmd-waypoints.json
echo "Testing setWaypoints...(update)"
$CMD -f test/cmd-setWaypoints-update.json
$CMD -f test/cmd-waypoints.json
echo "Testing setWaypoints...(delete)"
$CMD -f test/cmd-setWaypoints-delete.json
$CMD -f test/cmd-waypoints.json

echo "Testing some bad setConfiguration commands..."
$CMD -f test/cmd-setConfiguration-noconfiguration.json
$CMD -f test/cmd-setConfiguration-config-wrongtype.json
$CMD -f test/cmd-setConfiguration-badconfiguration.json
$CMD -f test/cmd-setConfiguration-config-notype.json

echo "Testing setConfiguration lock..."
$CMD -f test/cmd-setConfiguration-lock.json
echo "Testing setConfiguration unlock..."
$CMD -f test/cmd-setConfiguration-unlock.json

echo "Testing cards for me..."
$PUBINFO -f test/card-without-face.json
$PUBINFO -f test/card-vw.json

echo "Testing cards for my friend..."
$FRIINFO -f test/card-volvo.json

echo "Testing location message..."
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=0 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=-1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 tid=S1 m=1 cog=56`

exit

