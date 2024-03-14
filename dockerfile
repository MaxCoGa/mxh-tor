# base
FROM ubuntu:24.04

RUN apt update
RUN apt-get install -y --no-install-recommends wget ca-certificates
RUN apt-get install -y --no-install-recommends tor nginx

# make the script executable
RUN chmod +x config.sh


# set the entrypoint
# ENTRYPOINT ["/var/www/html"]