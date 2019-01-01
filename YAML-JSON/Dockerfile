FROM golang:alpine AS build-env

RUN apk add --no-cache git && \
    go get github.com/ghodss/yaml && \
    go get gopkg.in/yaml.v2

ENV VER_APP 0.0.1-20190101-1739

ADD ./src /src
WORKDIR /src
RUN go build -a \
        -tags netgo \
        -installsuffix netgo \
        --ldflags '-extldflags "-static"' \
        -o /src/yaml-json /src/yaml-json.go && \
    echo "変換の動作テスト YAML->JSON:" && \
    cat /src/sample.yml | /src/yaml-json -json

FROM busybox
COPY --from=build-env /src/yaml-json /usr/local/bin/yaml-json

#COPY --from=build-env /src/sample1.yml /root/sample1.yml
#RUN cat /root/sample1.yml | /usr/local/bin/yaml-json -json

ENTRYPOINT ["/usr/local/bin/yaml-json"]
