# Tor hidden service
ONION_DOMAIN_NAME=$1

WEBROOT="/var/www/$ONION_DOMAIN_NAME/html"
mkdir -p "$WEBROOT"
echo "<h1>Welcome to something...</h1>" | tee "$WEBROOT/index.html" > /dev/null

CERT_DIR="/etc/ssl/onion/$ONION_DOMAIN_NAME"
NGINX_CONF="/etc/nginx/sites-available/nginx-onion.conf"

tee "$NGINX_CONF" > /dev/null << EOF
server {
    listen 80;
    server_name $ONION_DOMAIN_NAME;

    location / {
        proxy_pass https://127.0.0.1:8443;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_ssl_verify off;
    }
}

server {
    listen 8443 ssl;
    server_name $ONION_DOMAIN_NAME;

    ssl_certificate $CERT_DIR/fullchain.pem;
    ssl_certificate_key $CERT_DIR/privkey.pem;


    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    root /var/www/$ONION_DOMAIN_NAME/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/

sed -i '/http {/a \    server_names_hash_bucket_size 128;' /etc/nginx/nginx.conf