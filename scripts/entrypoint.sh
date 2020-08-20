#!/bin/bash

set -e

if [ -f /app/app/wsgi.py ]; then
    DEFAULT_MODULE_NAME=app.wsgi
elif [ -f /app/wsgi.py ]; then
    DEFAULT_MODULE_NAME=wsgi
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-application}
export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}

exec "$@"