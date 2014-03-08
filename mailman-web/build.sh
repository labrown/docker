#!/bin/bash
set -e
source /build/buildconfig
set -x

# Install mailman and dependencies
$minimal_apt_get_install nginx spawn-fcgi fcgiwrap

# Add nginx configuration
cp /build/nginx.conf /etc/nginx/sites-available/mailman

echo "daemon off;" >> /etc/nginx/nginx.conf
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/mailman /etc/nginx/sites-enabled/
