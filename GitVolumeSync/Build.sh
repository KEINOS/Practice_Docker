#!/bin/bash

#  General variables
# ==============================================================================
source ./ENV.list

#  Prepare
# ==============================================================================

## Create docker volume for data to store git contents.
## This must be mounted at root such as /data_git
echo -n '- Searching data volume to git clone ... '
if [ ! "$(docker volume ls -q -f name=${NAME_VOLUME_DATA})" ]; then
    echo 'Not found.'
    echo -n "- Creating data volume '${NAME_VOLUME_DATA}' ... "
    docker volume create ${NAME_VOLUME_DATA}
fi
echo 'OK'

## Create docker volume for SSH to mount at /root/.ssh
echo -n '- Searching data volume for SSH files ... '
if [ ! "$(docker volume ls -q -f name=${NAME_VOLUME_SSH})" ]; then
    echo 'Not found.'
    echo -n "- Creating data volume '${NAME_VOLUME_SSH}' ... "
    docker volume create ${NAME_VOLUME_SSH}
    
    # Copy SSH keys to the volume created above.
    echo -n "- Copying SSH keys to volume '${NAME_VOLUME_SSH}' ...  "
    docker run \
        --name data_tmp \
        -v data_ssh:/data \
        busybox true
    docker cp -L ${PATH_FILE_RSA_PRIVATE} data_tmp:/data
    docker cp -L ${PATH_FILE_RSA_PUBLIC} data_tmp:/data
    docker rm data_tmp
fi
echo 'OK'

echo -n '- Removing old container ... '
if [ "$(docker container ls -q -f name=${NAME_CONTAINER_GIT})" ]; then
    docker container stop ${NAME_CONTAINER_GIT}
    docker container rm ${NAME_CONTAINER_GIT}
    docker container prune
fi
echo 'OK'
echo -n '- Removing old image ... '
if [ "$(docker image ls -q ${NAME_IMAGE_GIT})" ]; then
    docker image rm ${NAME_IMAGE_GIT}
    docker image prune --force
fi
echo 'OK'

#  Build image
# ==============================================================================

docker build -t ${NAME_IMAGE_GIT} .
if [ $? -ne 0 ]; then
    echo 'Failed to build image.'
    exit $LINENO
fi

#  Run container to monitor
# ==============================================================================
docker image prune --force && \
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
