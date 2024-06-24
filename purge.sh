#!/bin/sh

find /usr/share/nginx/html/ | sed 's:/usr/share/nginx/html::g' | xargs -I{} sh -c "echo Purging https://bootstrap.pypa.io{}; curl --silent -XPURGE https://bootstrap.pypa.io{}; echo;"
