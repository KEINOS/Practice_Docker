#!/bin/bash

# ==============================================================================

#  Load general variables
# ------------------------------------------------------------------------------
source ./ENV.list

#  Check if already ran
# ------------------------------------------------------------------------------
echo -n '- Checking existing container running ... '
if [ "$(docker container ls -q -f name=${NAME_CONTAINER_GIT})" ]; then
    echo 'OK'
    echo 'Monitoring container is already running:'
    docker container ls -f name=${NAME_CONTAINER_GIT}
    echo 
    echo "Mount volume '${NAME_VOLUME_DATA}' on to your container."
    exit 0
fi
echo 'OK'

#  Restart if stopped container exists
# ------------------------------------------------------------------------------
echo -n '- Checking existing stopped container ... '
if [ "$(docker container ls -a -q -f name=${NAME_CONTAINER_GIT})" ]; then
    echo 'FOUND'
    echo -n 'Stopped container found. Now re-starting ... '
    docker container start ${NAME_CONTAINER_GIT}
    if [ $? -eq 0 ]; then
        echo 'OK'
        echo "Now, mount volume '${NAME_VOLUME_DATA}' on to your container."
        exit 0
    fi
    docker container rm ${NAME_CONTAINER_GIT}
    docker container prune --force
fi
echo 'OK. No stopped container.'

#  Check if image exists
# ------------------------------------------------------------------------------
echo -n '- Checking existing image ... '
if [ ! "$(docker image ls -q ${NAME_IMAGE_GIT})" ]; then
    echo 'NG'
    echo "Image of monitoring container not found. (${NAME_IMAGE_GIT})"
    echo 'Now building image and setting up ...'
    /bin/bash ./Build.sh
    exit $?
fi
echo 'OK'

#  Run container to monitor
# ------------------------------------------------------------------------------
docker run --rm -it -d \
    --name ${NAME_CONTAINER_GIT} \
    --env-file ./ENV.list \
    -v ${NAME_VOLUME_DATA}:/data_git \
    -v ${NAME_VOLUME_SSH}:/root/.ssh \
    ${NAME_IMAGE_GIT}

if [ ! "$(docker container ls -q -f name=${NAME_CONTAINER_GIT})" ]; then
    echo 'Fail to run monitor container'
    exit 1
fi

cat <<EOL
All done.
--------------------------------------------------------------------------------
Monitor container "${NAME_CONTAINER_GIT}" is running background.
Now mount the cloned data voume "${NAME_VOLUME_DATA}" on your container's
directory like below:

    docker run --rm -it -v ${NAME_VOLUME_DATA}:/data alpine /bin/sh

All the changes in this directory (/data) will reflect to origin repository.

EOL

