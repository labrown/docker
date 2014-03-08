#!/bin/sh

docker build -t xavia/baseimage -rm baseimage/ \
  && docker build -t xavia/mailman -rm mailman/ \
  && docker build -t xavia/mailman-web -rm mailman-web/
