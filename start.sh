#!/bin/sh
#!/usr/bin/dumb-init /bin/sh
set -e

${USER_HOME}/server/relaysrv -listen=":${RELAY_PORT}" -status-srv=":${STATUS_PORT}" -keys="${USER_HOME}/certs" -global-rate="${RATE_GLOBAL}" -per-session-rate="${RATE_SESSION}" -message-timeout="${TIMEOUT_MSG}" -network-timeout="${TIMEOUT_NET}" -ping-interval="${PING_INT}" -provided-by="${PROVIDED_BY}" -pools="${POOLS}" ${RELAY_OPTS} &

while [ ! -f "${USER_HOME}/certs/cert.pem" ] || [ ! -f "${USER_HOME}/certs/key.pem" ]
do
  echo "waiting for certificates."
  sleep 1
done

${USER_HOME}/server/discosrv --listen=":${DISCO_PORT}" --db-dir="${USER_HOME}/db/discosrv.db" --cert="${USER_HOME}/certs/cert.pem" --key="${USER_HOME}/certs/key.pem" ${DISCO_OPTS} &

wait
