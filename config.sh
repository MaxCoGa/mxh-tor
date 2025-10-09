#!/bin/bash
set -e
alias status="ps aux | grep -E 'tor|nginx' | grep -v grep"

# cp tor-config /etc/tor/torrc
grep -q "HiddenServiceDir" /etc/tor/torrc || {
    echo -e "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 443 127.0.0.1:8443" >> /etc/tor/torrc
    echo -e "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc
}

# start Tor in background
TOR_LOG=$(mktemp)
tor -f /etc/tor/torrc --RunAsDaemon 0 &> "$TOR_LOG" &
TOR_PID=$!

# wait for Tor to finish bootstrap
echo "[INFO] Waiting for Tor to bootstrap..."
while ! grep -q "Bootstrapped 100% (done)" "$TOR_LOG"; do
    # check for errors
    if grep -q "\[err\]" "$TOR_LOG"; then
        echo "[ERROR] Tor reported an error during bootstrap:"
        grep "\[err\]" "$TOR_LOG"
        killall tor
        exit 1
    fi

    sleep 0.5
done
echo "[INFO] Tor bootstrapped successfully!"

# Show hostname
# wait until the hostname file exists (Tor finished setting up the hidden service)
echo "[INFO] Waiting for onion hostname..."
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
    sleep 0.5
done

ONION=$(cat /var/lib/tor/hidden_service/hostname)
echo "[INFO] Onion hostname: $ONION"

# generate certificate and nginx config
sh generate-onion-cert.sh "$ONION"
sh create-nginx-onion.sh "$ONION"

# nginx
nginx -t
nginx -g 'daemon off;' &
NGINX_PID=$!

echo "Hidden Service Hostname: $ONION"
wait -n $TOR_PID $NGINX_PID