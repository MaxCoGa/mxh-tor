#!/bin/bash
# Generate a self-signed SSL certificate for a .onion service
# Usage: ./generate-onion-cert.sh yourservice.onion

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <onion-domain>"
  exit 1
fi

CERT_DIR="/etc/ssl/onion/$DOMAIN"
CA_DIR="/etc/ssl/onion/ca"
mkdir -p "$CERT_DIR" "$CA_DIR"

# root ca
# openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
#   -nodes -keyout "$CA_DIR/rootCA.key" \
#   -out "$CA_DIR/rootCA.pem" \
#   -subj "/CN=nobody"

OPENSSL_CONF=$(mktemp)
cat > "$OPENSSL_CONF" <<EOF
[req]
default_bits       = 4096
distinguished_name = req_distinguished_name
req_extensions     = v3_req
prompt             = no

[req_distinguished_name]
CN = $DOMAIN

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
EOF


# faketime 'last week' openssl req -new -nodes -config "$OPENSSL_CONF" \
#   -keyout "$CERT_DIR/privkey.pem" \
#   -out "$CERT_DIR/cert.csr"

# faketime 'last week' openssl x509 -req -in "$CERT_DIR/cert.csr" \
#   -CA "$CA_DIR/rootCA.pem" -CAkey "$CA_DIR/rootCA.key" -CAcreateserial \
#   -out "$CERT_DIR/fullchain.pem" -days 365 -sha256 -extensions v3_req -extfile "$OPENSSL_CONF"

faketime 'last week' openssl req -x509 -newkey rsa:4096 -sha256 -nodes \
  -config "$OPENSSL_CONF" \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/fullchain.pem" \
  -days 365 \
  -extensions v3_req

# rm "$OPENSSL_CONF"

echo
echo "Self-signed certificate created:"
echo "  Certificate: $CERT_DIR/fullchain.pem"
echo "  Private Key: $CERT_DIR/privkey.pem"