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

  sed -i "s/^DEFAULT_EMAIL_HOST *=.*$/DEFAULT_EMAIL_HOST = '$MAILMAN_DOMAIN'/" /etc/mailman/mm_cfg.py
  sed -i "s/^DEFAULT_URL_HOST *=.*$/DEFAULT_URL_HOST   = '$MAILMAN_DOMAIN'/" /etc/mailman/mm_cfg.py
  sed -i "s/^DEFAULT_URL_PATTERN = 'http:\/\/%s\/cgi-bin\/mailman\/'$/DEFAULT_URL_PATTERN = 'http:\/\/%s\/mailman\/'/" /etc/mailman/mm_cfg.py

  if [ -f /etc/nginx/sites-available/mailman ]; then
    sed -i "s/__MAILMAN_DOMAIN__/$MAILMAN_DOMAIN/" /etc/nginx/sites-available/mailman
  fi
fi

if [ -f /build/services ]; then
  for service in `cat /build/services`; do
    ln -s /build/service-files/$service /etc/service/
  done
fi

echo "hostmaster: root" >> /etc/aliases
echo "root: matt@buffalolab.org" >> /etc/aliases
newaliases

exec "$@"
