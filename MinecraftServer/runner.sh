#!/usr/bin/env bash

docker-compose up -d

if [ $? -eq 0 ]; then
    echo "Now access from MC client to: `hostname`:25565"
fi
