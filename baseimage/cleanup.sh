#!/bin/bash
set -e
source /build/buildconfig
set -x

apt-get clean
rm -rf /build/build.sh
rm -rf /tmp/* /var/tmp/*
