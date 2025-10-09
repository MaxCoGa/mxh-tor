# base
FROM alpine:3.22.2

# install required packages
RUN apk add --no-cache \
    openrc \
    coreutils \
    bash \
    ca-certificates \
    openssl \
    libfaketime \
    tor \
    nginx \
    wget

# create working directory
WORKDIR /tor-config

COPY config.sh create-nginx-onion.sh generate-onion-cert.sh /tor-config/
RUN chmod +x /tor-config/*.sh

# ensure necessary dirs exist for tor and nginx
# RUN mkdir -p /var/lib/tor/hidden_service /run/nginx /var/www && \
#     chown -R tor:tor /var/lib/tor && \
#     chown -R nginx:nginx /var/www

# set the entrypoint
# ENTRYPOINT ["sh", "config.sh"]
# CMD ["cat", "/var/lib/tor/hidden_service/hostname"]


# Set default command to run your setup script and start services
CMD ["/bin/bash", "-c", "\
    sh /tor-config/config.sh \
"]