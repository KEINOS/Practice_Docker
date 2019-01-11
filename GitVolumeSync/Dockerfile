FROM alpine

ARG NAME_APP='git-volume-sync'
ARG GIT_NAME=''
ARG GIT_MAIL=''
ARG GIT_URL=''

ARG PATH_DIR_DATA='/data_git'
ARG PATH_DIR_RESOURCE='/resource'
ARG TIME_ZONE='Asia/Tokyo'

ENV NAME_APP=${NAME_APP} \
    GIT_MAIL=${GIT_MAIL} \
    GIT_NAME=${GIT_NAME} \
    GIT_URL=${GIT_URL} \
    PATH_FILE_LOG_ERROR="/var/log/${NAME_APP}_error.log" \
    PATH_DIR_DATA=${PATH_DIR_DATA} \
    PATH_DIR_RESOURCE=${PATH_DIR_RESOURCE} \
    TIME_SLEEP=300

RUN apk update \
    && apk add --no-cache \
        tzdata \
        openssh-keygen \
        git \
        openssh \
    && mkdir ${PATH_DIR_RESOURCE} \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo ${TIME_ZONE} > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

COPY .${PATH_DIR_RESOURCE}/* ${PATH_DIR_RESOURCE}/

VOLUME ${PATH_DIR_DATA}

CMD ${PATH_DIR_RESOURCE}/entrypoint.sh
