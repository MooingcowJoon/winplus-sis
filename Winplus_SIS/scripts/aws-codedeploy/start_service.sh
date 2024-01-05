#!/bin/bash

LOCAL_HEALTH_CHECK_URL='http://127.0.0.1:8080'
HEALTH_CHECK_TIMEOUT=180
HEALTH_CHECK_INTERVAL=3

if ! sudo service tomcat8 restart ; then
    echo "[-] Unable to start tomcat" >&2
    exit 1;
fi

echo

echo "[*] Waiting for application to start"

set +e

start=$(date +%s)
while true ; do
    echo -n "$(date '+%T'): "

    if curl --fail --silent --show-error --max-time 1 -o /dev/null "$LOCAL_HEALTH_CHECK_URL" ; then
        echo "[+] Application started"
        break
    fi

    now=$(date +%s)
    elasped=$(($now - $start))

    if [[ $elasped -gt $HEALTH_CHECK_TIMEOUT ]]; then
        echo "[-] Application not started within $HEALTH_CHECK_TIMEOUT seconds" >&2
        exit 1
    fi

    sleep $HEALTH_CHECK_INTERVAL
done