#!/bin/bash
set -e
source /build/buildconfig
set -x

## Enable Ubuntu Universe.
# @TODO add extra debian repos here?
#echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list
#echo deb http://archive.ubuntu.com/ubuntu precise-updates main universe >> /etc/apt/sources.list
apt-get update

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Upgrade all packages.
echo "initscripts hold" | dpkg --set-selections
apt-get upgrade -y --no-install-recommends

## Fix locale.
export LANG
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
$minimal_apt_get_install locales
update-locale LANG=en_US.UTF-8 && . /etc/default/locale

## Install runit.
$minimal_apt_get_install runit

## Install a syslog daemon.
$minimal_apt_get_install rsyslog
