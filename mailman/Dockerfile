FROM xavia/baseimage
MAINTAINER Matt Lehner <mlehner@gmail.com>

ENV HOME /root

# Add our build scripts
RUN mkdir -p /build
ADD . /build

RUN /build/build.sh && \
	/build/cleanup.sh

EXPOSE 25
