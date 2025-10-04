
# mxh-tor

## Build the container image

    docker build -f Dockerfile -t mxh-tor

## Execute the container

    docker run -itd --name mxh-tor-1 mxh-tor

## Get hostname

    docker logs mxh-tor-1 | awk '/Hidden Service Hostname:/ {getline; print}'

## See logs

    docker logs mxh-tor-1

## Automatically restart

    docker update --restart unless-stopped mxh-tor-1

## Enter inside the container

    docker exec -it mxh-tor-1 bash

## Copy files to the container
Replace ONION_HOSTNAME with yours.

    docker cp index.html mxh-tor-1:/var/www/ONION_HOSTNAME/html/

or

    docker cp myfolder/ mxh-tor-1:/var/www/ONION_HOSTNAME/html/

## Destory a container

    docker stop mxh-tor-1
    docker rm mxh-tor-1
