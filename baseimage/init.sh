#!/bin/sh

echo `hostname -f` > /etc/mailname
postconf -e "myhostname = `hostname -f`" 

if [ -n $MAILMAN_DOMAIN ]; then
  postconf -e "mydestination = $MAILMAN_DOMAIN, `hostname -f`, localhost.localdomain, localhost"
else
  postconf -e "mydestination = `hostname -f`, localhost.localdomain, localhost"
fi

if [ -n $MAILMAN_DOMAIN ]; then
  echo "$MAILMAN_DOMAIN mailman:" > /etc/postfix/transport
  postmap /etc/postfix/transport

  sed -i "s/DEFAULT_EMAIL_HOST = 'localhost.localdomain'/DEFAULT_EMAIL_HOST = '$MAILMAN_DOMAIN'/" /etc/mailman/mm_cfg.py
  sed -i "s/DEFAULT_URL_HOST   = 'localhost.localdomain'/DEFAULT_URL_HOST   = '$MAILMAN_DOMAIN'/" /etc/mailman/mm_cfg.py
fi

exec "$@"
