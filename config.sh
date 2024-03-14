cp tor-config /etc/tor/torrc
systemctl restart tor

# Show hostname
cat /var/lib/tor/hidden_service/hostname

# nginx
cd /var/www/html
systemctl restart nginx
