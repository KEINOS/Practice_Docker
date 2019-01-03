#!/usr/bin/env bash

#  User Settings
# ===============

# WAN Side Port
PORT_OUTSIDE=9001
# LAN (Container) Side Port
PORT_INSIDE=9000

# DockerUI image
NAME_IMAGE=kevan/dockerui

# Function
is_mac () {
    sw_vers > /dev/null 2>&1
    return $?    
}

# Main - Run container as daemon
docker run -d \
    -p $PORT_OUTSIDE:$PORT_INSIDE \
    --name dockerui \
    -v /var/run/docker.sock:/var/run/docker.sock \
    $NAME_IMAGE

# Launch
if [ $? -eq 0 ] ; then
    URL_DOCKERUI="http://localhost:${PORT_OUTSIDE}/"
    echo 'DockerUI launched.'
    echo "Access to: ${URL_DOCKERUI}"
    if is_mac ; then
        echo 'Opening safari ...'
        open -a safari $URL_DOCKERUI
    fi
    exit $?
fi

echo 'Error occured while launching DockerUI.'
exit 1
