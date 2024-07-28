# mxh-tor

echo -e "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 80 127.0.0.1:5000" | sudo tee -a /etc/tor/torrc
