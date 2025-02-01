# bootstrap.pypa.io

[bootstrap.pypa.io](https://bootstrap.pypa.io) is a service hosted by the
[Python Software Foundation](https://python.org/psf-landing) for the
[Python Packaging Authority](https://pypa.io)
to provide bootstrapping scripts for common packaging tools
to environments that may not already have them.

This repository hosts the assets used to build and serve the service.

## Locally testing

You can construct and test the image locally after cloning the repository

```shell
docker build -t bootstrap_pypa_io .
docker run --rm -p 8080:8080 bootstrap_pypa_io
```

The service is then available at `http://localhost:8080`

You can build from a different version of a given source using Docker build-args:

```shell
docker build -t bootstrap_pypa_io --build-arg get_pip_branch=24.1 .
```

Current args are:

```
ARG get_pip_branch=main
ARG get_virtualenv_branch=main
ARG setuptools_branch=bootstrap
ARG buildout_branch=bootstrap-release
```

## Dockerfile

The [`Dockerfile`](Dockerfile)

1. Retrieves upstream sources from
[get-pip](https://github.com/pypa/get-pip.git),
[get-virtualenv](https://github.com/pypa/get-virtualenv.git),
[setuptools](https://github.com/pypa/setuptools/tree/bootstrap),
and [buildout](https://github.com/buildout/buildout/tree/bootstrap-release).
1. Constructs the directory that will be served at bootstrap.pypa.io
1. Builds a container for serving the directory via nginx and executing CDN purges 

## CDN purging

[`purge.sh`](purge.sh) is run after successful deployments to purge all
files served by `bootstrap.pypa.io`.

## Updating

Changes to upstream sources are tracked via the
[monitor](.github/workflows/monitor.yml)
GitHub Action.

When changes are detected, a
[commit](https://github.com/pypa/bootstrap/commit/29e93d5e3e26bce890905906b634488c5b3416ec)
will automatically be created.

Once our ["tests"](.github/workflows/ci.yml) have passed, a
[deployment](https://github.com/pypa/bootstrap/deployments)
will automatically be started. Once complete the [`purge.sh`](purge.sh)
script will be run to purge the CDN cache.
