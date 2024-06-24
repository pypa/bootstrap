#!/bin/sh

find /usr/share/nginx/html/ | sed 's:/usr/share/nginx/html::g' | xargs -I{} sh -c "echo https://bootstrap.pypa.io{}; curl -XPURGE https://bootstrap.pypa.io{}; echo;"
