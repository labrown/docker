#!/bin/sh

docker run -d -name smokeping -volumes-from smokeping-data -u smokeping xavia/smokeping /usr/sbin/smokeping --config /etc/smokeping/config --nodaemon
