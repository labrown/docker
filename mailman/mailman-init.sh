#!/bin/sh

docker run -d -p 25:25 -name mailman -volumes-from mailman-data xavia/mailman /usr/sbin/runsvdir-start
