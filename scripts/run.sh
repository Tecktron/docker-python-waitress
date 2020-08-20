#!/bin/bash

set -e

# If there's a prestart.sh script in the /app directory, run it before starting
PRE_START_PATH=/app/prestart.sh
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . "$PRE_START_PATH"
else
    echo "There is no script $PRE_START_PATH"
fi

params="--listen=*:80"

if [[ -v WAITRESS_THREADS ]]; then
  params=" $params --thread=$WAITRESS_THREADS"
fi
if [[ -v WAITRESS_IDENT ]]; then
  params=" $params --ident=$WAITRESS_IDENT"
fi
if [[ -v WAITRESS_OUTBUF_OVERFLOW ]]; then
  params=" $params --outbuf_overflow=$WAITRESS_OUTBUF_OVERFLOW"
fi
if [[ -v WAITRESS_OUTBUF_HIGH_WATERMARK ]]; then
  params=" $params --outbuf_high_watermark=$WAITRESS_OUTBUF_HIGH_WATERMARK"
fi
if [[ -v WAITRESS_INBUF_OVERFLOW ]]; then
  params=" $params --inbuf_overflow=$WAITRESS_INBUF_OVERFLOW"
fi
if [[ -v WAITRESS_CONNECTION_LIMIT ]]; then
  params=" $params --connection_limit=$WAITRESS_CONNECTION_LIMIT"
fi
if [[ -v WAITRESS_MAX_REQUEST_HEADER_SIZE ]]; then
  params=" $params --max_request_header_size=$WAITRESS_MAX_REQUEST_HEADER_SIZE"
fi
if [[ -v WAITRESS_MAX_REQUEST_BODY_SIZE ]]; then
  params=" $params --max_request_body_size=$WAITRESS_MAX_REQUEST_BODY_SIZE"
fi
if [[ -v WAITRESS_EXPOSE_TRACEBACKS ]]; then
  params=" $params --expose_tracebacks=$WAITRESS_EXPOSE_TRACEBACKS"
fi
if [[ -v WAITRESS_ASYNCORE_LOOP_TIMEOUT ]]; then
  params=" $params --asyncore_loop_timeout=$WAITRESS_ASYNCORE_LOOP_TIMEOUT"
fi
if [[ -v WAITRESS_ASYNCORE_USE_POLL ]]; then
  params=" $params --asyncore_use_poll=$WAITRESS_ASYNCORE_USE_POLL"
fi

# Start Waitress
exec waitress-serve $params $APP_MODULE