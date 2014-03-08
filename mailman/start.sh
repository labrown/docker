#!/bin/sh

#docker run -d -p 25:25 -name mailman -volumes-from mailman-data xavia/mailman /usr/sbin/runsvdir-start
docker run \
  -e RELAY_DOMAINS=lists.thefoundrybuffalo.org \
  -e MAILMAN_DOMAIN=lists.thefoundrybuffalo.org \
  -volumes-from mailman-data \
  -d -p 25:25 \
  -name mailman \
  -h foundry.xavia.org \
  xavia/mailman
