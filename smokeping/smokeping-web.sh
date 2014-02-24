#!/bin/sh

docker run -d -expose 9000 -name smokeping-web -volumes-from smokeping-data -u www-data xavia/smokeping /usr/bin/spawn-fcgi -n -p 9000 -- /usr/lib/cgi-bin/smokeping.cgi
