FROM php:7.3.1

ARG VERSION_APP=20190112-1605
RUN mkdir /app
COPY src/* /app/
COPY server_start.sh /server_start.sh
ENTRYPOINT /server_start.sh
