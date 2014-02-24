FROM stackbrew/debian

MAINTAINER Matt Lehner <mlehner@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install mailman postfix spawn-fcgi
