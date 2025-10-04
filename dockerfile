# base
FROM ubuntu:24.04

RUN apt update
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends libfaketime faketime openssl wget tor nginx

# make the script executable
WORKDIR /tor-config
COPY config.sh create-nginx-onion.sh generate-onion-cert.sh /tor-config/
RUN chmod +x config.sh create-nginx-onion.sh generate-onion-cert.sh


# set the entrypoint
# ENTRYPOINT ["sh", "config.sh"]
# CMD ["cat", "/var/lib/tor/hidden_service/hostname"]


# Set default command to run your setup script and start services
CMD ["/bin/bash", "-c", "\
    sh /tor-config/config.sh && \
    echo 'Hidden Service Hostname:' && \
    cat /var/lib/tor/hidden_service/hostname && \
    nginx -g 'daemon off;' \
"]