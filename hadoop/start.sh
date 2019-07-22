#!/bin/bash

/etc/init.d/ssh start
# service ssh restart

export SPARK_IP_ADDRESS=$(ip -4 -o address show dev eth0 | egrep -o "(([0-9.]{1,3}){3}.[0-9]{1,3})" | head -2)


/usr/local/hadoop/sbin/start-dfs.sh
/usr/local/hadoop/sbin/start-yarn.sh

start-all.sh

service mysql start

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

