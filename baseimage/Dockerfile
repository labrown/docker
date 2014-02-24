FROM stackbrew/debian
MAINTAINER "Matt Lehner" <mlehner@gmail.com>

ENV HOME /root

# Build scripts for this Dockerfile
RUN mkdir /build
ADD . /build

RUN /build/build.sh && \
	/build/cleanup.sh

CMD ["/usr/sbin/runsvdir-start"]
