#!/bin/sh

docker run -rm -volumes-from mailman-data -i -t xavia/mailman /bin/bash
