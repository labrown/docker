#!/bin/sh

#docker run -rm -volumes-from mailman-data -i -t xavia/mailman /bin/bash
docker run \
  -e RELAY_DOMAINS=lists.thefoundrybuffalo.org \
  -e MAILMAN_DOMAIN=lists.thefoundrybuffalo.org \
  -volumes-from mailman-data \
  -rm -i -t \
  -h foundry.xavia.org \
  xavia/mailman \
  /bin/bash
