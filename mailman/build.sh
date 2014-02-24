#!/bin/bash
set -e
source /build/buildconfig
set -x

# Install mailman and dependencies
$minimal_apt_get_install mailman postfix spawn-fcgi

# Enable mailman service
cp -R /build/service-files/mailman /etc/service

# Enable postfix service
cp -R /build/service-files/postfix /etc/service
