# Python Waitress Docker Container

A Docker container to run a WSGI Python application using
[Waitress](https://docs.pylonsproject.org/projects/waitress/en/stable/index.html). Images support python 3.6+ and are
based on the [official python containers](https://hub.docker.com/_/python). The `-slim` versions are based on the similarly named python versions.

[Pull from Docker Hub](https://hub.docker.com/r/tecktron/python-waitress/)

[View on GitHub](https://github.com/Tecktron/docker-python-waitress)

## How to use

* You don't need to clone the GitHub repo. You can use this image as a base image for other images, using this in your `Dockerfile`:

```Dockerfile
FROM tecktron/python-waitress:latest

COPY ./ /app
```

It will expect a file at `/app/app/wsgi.py`.

Or otherwise a file at `/app/wsgi.py`.

And will expect it to contain a variable `application` with your "WSGI" application.

Then you can build your image from the directory that has your `Dockerfile`, e.g:

```bash
docker build -t myimage ./
```

## Options

All options can be set using environment variables. These can be passed either in a wrapper dockerfile, passing in a .env file or passing them with the
-e flag to the docker call.

### Prestart Script
If you need to run any startup commands before Waitress runs (an example might be running migrations) you can override the `prestart.sh` script. This script should live within the `/app` directory in the container. The image will automatically detect and run it before starting Waitress.


### Variables

#### `MODULE_NAME`

The Python "module" (file) to be imported by Waitress, this module would contain the actual application in a variable.

By default:

* `app.wsgi` if there's a file `/app/app/main.py` or
* `wsgi` if there's a file `/app/wsgi.py`

For example, if your main file was at `/app/custom_app/custom_script.py`, you could set it like:

```bash
docker run -d -p 80:80 -e MODULE_NAME="custom_app.custom_script" myimage
```

#### `VARIABLE_NAME`

The variable inside of the Python module that contains the WSGI application.

By default:

* `application`

For example, if your main Python file has something like:

```Python
from flask import Flask
api = Flask(__name__)

@api.route("/")
def hello():
    return "Hello World from Flask"
```

In this case `api` would be the variable with the "WSGI application". You could set it like:

```bash
docker run -d -p 80:80 -e VARIABLE_NAME="api" myimage
```

#### `APP_MODULE`

The string with the Python module and the variable name passed to Waitress.

By default, set based on the variables `MODULE_NAME` and `VARIABLE_NAME`:

* `app.wsgi:application` or
* `wsgi:application`

You can set it like:

```bash
docker run -d -p 80:80 -e APP_MODULE="custom_app.custom_script:api" myimage
```

### Waitress Options

#### Host & Port Setup
By default, Waitress has been setup to server on all hostnames on port 80 using both IPv4 and IPv6. This translates to `--listen:*:80`. This works for most applications using the basic setups listed above.

You may have different needs so you can adjust and manipulate this by passing in environment variable to adjust the settings.

There are 2 options for doing this:


1. Pass a comma separated list of `host:port,host:port` to the `WAITRESS_LISTEN` param

The `WAITRESS_LISTEN` param takes precedence over `WAITRESS_HOST`/`WAITRESS_PORT` options, meaning if you include all 3, host and port settings will be ignored.

To set Waitress to use port 8080, sent the `WAITRESS_LISTEN` param like 
```bash
docker run -d -p 80:8080 -e WAITRESS_LISTEN=*:8080 myimage
````

2. Pass the host and port separately as `WAITRESS_HOST` and/or `WAITRESS_PORT`. If port is left out, it will default to 80.

If you want only IPv4, you could use advanced param listed in the section below, but you could also use
```bash
docker run -d -p 80:8080 -e WAITRESS_HOST=0.0.0.0 -e WAITRESS_PORT=8080 myimage
````

#### Advanced Options

Many of the
[options](https://docs.pylonsproject.org/projects/waitress/en/stable/runner.html#invocation) that can be passed to `waitress-serve` 
are supported by passing in environment variables. These params are only included in the `waitress-serve` call if they are present
in the environment. The supported options are:

| Environment Variable             | Waitress Param                   |
|:---------------------------------|:---------------------------------|
| WAITRESS_EXPOSE_TRACEBACKS       | --expose-tracebacks              |
| WAITRESS_NO_EXPOSE_TRACEBACKS    | --no-expose-tracebacks           |
| WAITRESS_NO_IPV6                 | --no-ipv6                        |
| WAITRESS_NO_IPV4                 | --no-ipv4                        |
| WAITRESS_THREADS                 | --threads=`$VAL`                 |
| WAITRESS_IDENT                   | --ident=`$VAL`                   |
| WAITRESS_OUTBUF_OVERFLOW         | --outbuf_high_watermark=`$VAL`   |
| WAITRESS_INBUF_OVERFLOW          | --inbuf_overflow=`$VAL`          |
| WAITRESS_CONNECTION_LIMIT        | --connection_limit=`$VAL`        |
| WAITRESS_MAX_REQUEST_HEADER_SIZE | --max_request_header_size=`$VAL` |
| WAITRESS_MAX_REQUEST_BODY_SIZE   | --max_request_body_size=`$VAL`   |
| WAITRESS_ASYNCORE_LOOP_TIMEOUT   | --asyncore_loop_timeout=`$VAL`   |
| WAITRESS_ASYNCORE_USE_POLL       | --asyncore_use_poll=`$VAL`       |

Where `$VAL` is the value passed into the environment. For example, to set the number of threads to 5 use:
```bash
docker run -d -p 80:80 -e WAITRESS_THREADS=5 myimage
```
Translates to command
```bash
waitress-serve --listen=*:80 --threads=5 app.wsgi:application
```


For those without any value, simply pass a 1. For example, to turn off IPv6 use:
```bash
docker run -d -p 80:80 -e WAITRESS_NO_IPV6=1 myimage
```
Translates to command
```bash
waitress-serve --listen=*:80 --no-ipv6 app.wsgi:application
```

# Credits
This dockerfile setup is based on https://github.com/tiangolo/meinheld-gunicorn-docker

Waitress is one of the Pylons projects: https://pylonsproject.org

Python is by the Python Software Foundation. https://python.org

Docker is by Docker, Inc. https://docker.com

Built using open source software.
