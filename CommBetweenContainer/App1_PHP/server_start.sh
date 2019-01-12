#!/bin/bash

IP_ADDRESS=`hostname -i`

echo "IP:${IP_ADDRESS}"

php -S ${IP_ADDRESS}:80 /app/Main.php > /dev/null

