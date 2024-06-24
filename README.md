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
docker build -t getpip .
docker run --rm -p 8080:8000 getpip
```

The service is then available at `http://localhost:8080`

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
