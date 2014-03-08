#!/bin/sh

docker run \
  -e MAILMAN_DOMAIN=lists.thefoundrybuffalo.org \
  -volumes-from mailman-data \
  -d -p 127.0.0.1:8080:80 \
  -name mailman-web \
  -h foundry.xavia.org \
  xavia/mailman-web
