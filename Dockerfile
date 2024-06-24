FROM alpine/git:2.45.2 AS fetch

RUN mkdir -p /srv/src
RUN mkdir -p /srv/html

RUN git clone --filter=tree:0 https://github.com/pypa/get-pip.git /srv/src/pip
RUN cp -r /srv/src/pip/public /srv/html/pip
RUN cp /srv/src/pip/public/get-pip.py /srv/html/get-pip.py

RUN git clone --filter=tree:0 https://github.com/pypa/get-virtualenv.git /srv/src/virtualenv
RUN cp -r /srv/src/virtualenv/public /srv/html/virtualenv
RUN cp /srv/src/virtualenv/public/virtualenv.pyz /srv/html/virtualenv.pyz

RUN git clone --filter=tree:0 --branch bootstrap https://github.com/pypa/setuptools /srv/src/setuptools
RUN cp /srv/src/setuptools/ez_setup.py /srv/html/ez_setup.py

RUN git clone --filter=tree:0 --branch bootstrap-release https://github.com/buildout/buildout.git /srv/src/buildout
RUN cp /srv/src/buildout/bootstrap/bootstrap.py /srv/html/bootstrap-buildout.py


FROM nginx:1.27.0-alpine-slim AS serve
RUN apk add curl

RUN rm -rf /usr/share/nginx/html
RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/run/cabotage
RUN chown nobody:nobody /var/run/cabotage

COPY nginx.conf /etc/nginx/nginx.conf
COPY get-pip.conf /etc/nginx/conf.d/get-pip.conf
COPY --from=fetch /srv/html /usr/share/nginx/html

COPY purge.sh /usr/local/bin/purge.sh

USER nobody
