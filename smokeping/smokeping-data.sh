#!/bin/sh

docker run -v /var/lib/smokeping -v /etc/smokeping -v /var/cache/smokeping -name smokeping-data busybox true
