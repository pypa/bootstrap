FROM alpine/git:2.45.2 AS fetch-base

RUN mkdir -p /srv/src

FROM fetch-base AS fetch-get-pip
ARG get_pip_branch=main
ADD https://api.github.com/repos/pypa/get-pip/commits/${get_pip_branch} get-pip-version.json
RUN git clone --filter=tree:0 --branch ${get_pip_branch} https://github.com/pypa/get-pip.git /srv/src/pip

FROM fetch-base AS fetch-get-virtualenv
ARG get_virtualenv_branch=main
ADD https://api.github.com/repos/pypa/get-virtualenv/commits/${get_virtualenv_branch} get-virtualenv-version.json
RUN git clone --filter=tree:0 --branch ${get_virtualenv_branch} https://github.com/pypa/get-virtualenv.git /srv/src/virtualenv

FROM fetch-base AS fetch-setuptools
ARG setuptools_branch=bootstrap
ADD https://api.github.com/repos/pypa/setuptools/commits/${setuptools_branch} setuptools-version.json
RUN git clone --filter=tree:0 --branch ${setuptools_branch} https://github.com/pypa/setuptools /srv/src/setuptools

FROM fetch-base AS fetch-buildout
ARG buildout_branch=bootstrap-release
ADD https://api.github.com/repos/buildout/buildout/commits/${buildout_branch} buildout-version.json
RUN git clone --filter=tree:0 --branch ${buildout_branch} https://github.com/buildout/buildout.git /srv/src/buildout


FROM scratch AS build

COPY --from=fetch-get-pip /srv/src/pip/public /html/pip
COPY --from=fetch-get-pip /srv/src/pip/public/get-pip.py /html/get-pip.py

COPY --from=fetch-get-virtualenv /srv/src/virtualenv/public /html/virtualenv
COPY --from=fetch-get-virtualenv /srv/src/virtualenv/public/virtualenv.pyz /html/virtualenv.pyz

COPY --from=fetch-setuptools /srv/src/setuptools/ez_setup.py /html/ez_setup.py

COPY --from=fetch-buildout /srv/src/buildout/bootstrap/bootstrap.py /html/bootstrap-buildout.py


FROM nginx:1.27.0-alpine-slim
RUN apk add curl

RUN rm -rf /usr/share/nginx/html
RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/run/cabotage
RUN chown nobody:nobody /var/run/cabotage

COPY purge.sh /usr/local/bin/purge.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY get-pip.conf /etc/nginx/conf.d/get-pip.conf
COPY --from=build /html /usr/share/nginx/html

USER nobody
