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
FRIPUBNORETAIN="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND -q 1"
FRIEVENT="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND/event -q 1"
FRIINFO="mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_FRIEND/info -r -q 1"

echo $CMD

echo "Running OwnTracks cmd tests against an OwnTracks device"
echo "You may want to follow the results by mosquitto_sub -t '#' | jq"

echo

if [ -z $1 ] || [ "$1" = "corrupt" ] ; then
echo "Testing some corrupt or illegal messages..."
$CMD -f test/array-empty.json
$CMD -f test/object-empty.json
$CMD -f test/cmd-illegal-action.json
$CMD -f test/cmd-without-action.json
fi

if [ -z $1 ] || [ "$1" = "simple" ] ; then
echo "Testing status..."
$CMD -f test/cmd-status.json
echo "Testing dump..."
$CMD -f test/cmd-dump.json
echo "Testing reportLocation..."
$CMD -f test/cmd-reportLocation.json

echo "Testing reportSteps... you may not get an immediate response because the device prompts the user for access to fitness data"
$CMD -f test/cmd-reportSteps.json
fi

if [ -z $1 ] || [ "$1" = "waypoint" ] ; then
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
echo "Testing setWaypoints illegal timestamp..."
$CMD -f test/cmd-setWaypoints-illegal.json
fi

if [ -z $1 ] || [ "$1" = "configuration" ] ; then
echo "Testing some bad setConfiguration commands..."
$CMD -f test/cmd-setConfiguration-noconfiguration.json
$CMD -f test/cmd-setConfiguration-config-wrongtype.json
$CMD -f test/cmd-setConfiguration-badconfiguration.json
$CMD -f test/cmd-setConfiguration-config-notype.json

echo "Testing setConfiguration lock..."
$CMD -f test/cmd-setConfiguration-lock.json
echo "Testing setConfiguration unlock..."
$CMD -f test/cmd-setConfiguration-unlock.json
fi

if [ -z $1 ] || [ "$1" = "card" ] ; then
echo "Testing cards for me..."
$PUBINFO -f test/card-without-face.json
$PUBINFO -f test/card-without-name.json
$PUBINFO -f test/card-without-all.json
$PUBINFO -f test/card-invalid-b64.json
$PUBINFO -f test/card-vw.json

echo "Testing cards for my friend..."
$FRIINFO -f test/card-volvo.json
fi

if [ -z $1 ] || [ "$1" = "location" ] ; then
echo "Testing location message..."
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=0 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=-1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 vac=1 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 acc=52 tid=S1 m=1 cog=56`
$FRIPUB -m `jo _type=location lat=44.221389 lon=6.64635 tst=\`date +%s\` batt=55 vel=54 alt=53 tid=S1 m=1 cog=56`
$FRIPUBNORETAIN -m `jo _type=lwt tst=1708703389` # ios style lwt
$FRIPUBNORETAIN -m `jo _type=lwt` # Android style lwt
fi

if [ -z $1 ] || [ "$1" = "event" ] ; then
echo "Testing bad event messages..."
$FRIEVENT -m '[]'
#tst type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=abc wtst=1708705570 rid=49b4ab t=1 tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=null wtst=1708705570 rid=49b4ab t=1 tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#t type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=1 tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=null tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab tid=S1 acc=5 desc=HIGHSPEED event=enter`

#event type
#$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=1`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=null`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED`

#desc type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=bla`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=null event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 event=enter`

#_type type
$FRIEVENT -m `jo _type=1 lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=null lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo  lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#rid type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=1 t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=null t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#tid type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=null acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c acc=5 desc=HIGHSPEED event=enter`

#lat type
$FRIEVENT -m `jo _type=transition lat=abc lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=null lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#lon type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=abc tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=null tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#wtst type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=abc rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=null rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`

#acc type
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=a desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=null desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 desc=HIGHSPEED event=enter`

echo "Testing event messages..."
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=37.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=b tid=S1 acc=5 desc=HIGHSPEED event=enter`
$FRIEVENT -m `jo _type=transition lat=38.442964 lon=-122.252948 tst=\`date +%s\` wtst=1708705570 rid=49b4ab t=c tid=S1 acc=5 desc=HIGHSPEED event=exit`
fi

exit

