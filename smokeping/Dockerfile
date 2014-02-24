FROM stackbrew/debian

MAINTAINER Matt Lehner <mlehner@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install smokeping ssmtp spawn-fcgi
RUN mkdir /var/run/smokeping
RUN chown smokeping:root /var/run/smokeping

CMD ["/usr/sbin/smokeping", "--config", "/etc/smokeping/config", "--nodaemon"]
