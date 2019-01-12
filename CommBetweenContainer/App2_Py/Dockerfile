FROM python:3.6.5

ARG VERSION_APP=20190113-0108
ARG PATH_DIR_PY=/home/python

RUN groupadd web && \
    useradd -d ${PATH_DIR_PY} -m python && \
    mkdir -p ${PATH_DIR_PY}/cgi-bin

WORKDIR ${PATH_DIR_PY}

COPY src/DocumentRoot/* ${PATH_DIR_PY}/
COPY src/cgi-bin/* ${PATH_DIR_PY}/cgi-bin/
COPY server_start.py /server_start.py

RUN chmod -R 0755 ${PATH_DIR_PY}/cgi-bin/*

ENTRYPOINT ["/usr/local/bin/python", "/server_start.py"]
USER root
