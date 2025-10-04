# cp tor-config /etc/tor/torrc
# echo -e "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 80 127.0.0.1:8443" | tee -a /etc/tor/torrc
echo "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 443 127.0.0.1:8443" | tee -a /etc/tor/torrc
echo "\nHiddenServicePort 80 127.0.0.1:80" | tee -a /etc/tor/torrc
service tor restart

# Show hostname
cat /var/lib/tor/hidden_service/hostname
ONION=$(cat /var/lib/tor/hidden_service/hostname)

sh generate-onion-cert.sh "$ONION"
sh create-nginx-onion.sh "$ONION"
# nginx
nginx -t
service nginx stop

cat /var/lib/tor/hidden_service/hostname