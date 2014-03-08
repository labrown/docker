#!/bin/bash
set -e
source /build/buildconfig
set -x

# Install mailman and dependencies
$minimal_apt_get_install mailman postfix

# Enable alias support for Postfix -> Mailman
postconf -e "alias_maps = hash:/etc/aliases, hash:/var/lib/mailman/data/aliases"
postconf -e "transport_maps = hash:/etc/postfix/transport"
postconf -e "mailman_destination_recipient_limit = 1"
