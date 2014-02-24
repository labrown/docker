#!/bin/sh

docker run -volumes-from mailman-data -i -t xavia/mailman /bin/bash
