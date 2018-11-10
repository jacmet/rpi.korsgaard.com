#!/bin/sh
# owntracks HTTP API to MQTT translation

# mosquitto_pub arguments
ARGS="-h 172.16.20.2"

cleanup() {
  rm -f $TMP
}

trap cleanup HUP INT TERM EXIT

TMP=$(mktemp -t own.XXXXXX)

cat > $TMP

TYPE="$(jq -r ._type $TMP)"

case "$TYPE" in
  cmd) SUB="cmd" ;;
  transition) SUB="event" ;;
  location) SUB=""; ARGS="$ARGS -r" ;;
  *) SUB="" ;;
esac

TOPIC="owntracks/$REMOTE_USER/phone"

if [ -n "$SUB" ]; then
  TOPIC="$TOPIC/$SUB"
fi

# forward to mqtt
if mosquitto_pub $ARGS -t "$TOPIC" -f "$TMP"; then
  printf 'Content-type: application/json\r\n'
  printf '\r\n'
  printf '[]'
else
  printf 'HTTP/500 Internal error (%d)\r\n' $?
fi
