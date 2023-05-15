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

params="$WAITRESS_EXTRA_PARAMS"

if [[ -v $WAITRESS_LISTEN ]]; then
  listeners=$(echo "$WAITRESS_LISTEN" | tr "," "\n")
  for listener in $listeners
  do
    if [[ -z $params ]]; then
      params="--listen=$listener"
    else
      params=" $params --listen=$listener"
    fi
  done
else
  if [[ -v $WAITRESS_HOST ]]; then
    if [[ -z $params ]]; then
      params="--host=$WAITRESS_HOST"
    else
      params=" $params --host=$WAITRESS_HOST"
    fi
  fi
  if [[ -v $WAITRESS_PORT ]]; then
    if [[ -z $params ]]; then
      params="--port=$WAITRESS_PORT"
    else
      params=" $params --port=$WAITRESS_PORT"
    fi
  fi
fi

if [[ -z $params ]]; then
    params="--listen=*:80"
fi

if [[ -v $WAITRESS_CALL ]]; then
  params=" $params --call"
fi
if [[ -v $WAITRESS_NO_IPV6 ]]; then
  params=" $params --no-ipv6"
fi
if [[ -v $WAITRESS_NO_IPV4 ]]; then
  params=" $params --no-ipv4"
fi
if [[ -v $WAITRESS_EXPOSE_TRACEBACKS ]]; then
  params=" $params --expose-tracebacks"
fi
if [[ -v $WAITRESS_NO_EXPOSE_TRACEBACKS ]]; then
  params=" $params --no-expose-tracebacks"
fi
if [[ -v $WAITRESS_THREADS ]]; then
  params=" $params --thread=$WAITRESS_THREADS"
fi
if [[ -v $WAITRESS_IDENT ]]; then
  params=" $params --ident=$WAITRESS_IDENT"
fi
if [[ -v $WAITRESS_OUTBUF_OVERFLOW ]]; then
  params=" $params --outbuf_overflow=$WAITRESS_OUTBUF_OVERFLOW"
fi
if [[ -v $WAITRESS_OUTBUF_HIGH_WATERMARK ]]; then
  params=" $params --outbuf_high_watermark=$WAITRESS_OUTBUF_HIGH_WATERMARK"
fi
if [[ -v $WAITRESS_INBUF_OVERFLOW ]]; then
  params=" $params --inbuf_overflow=$WAITRESS_INBUF_OVERFLOW"
fi
if [[ -v $WAITRESS_CONNECTION_LIMIT ]]; then
  params=" $params --connection_limit=$WAITRESS_CONNECTION_LIMIT"
fi
if [[ -v $WAITRESS_MAX_REQUEST_HEADER_SIZE ]]; then
  params=" $params --max_request_header_size=$WAITRESS_MAX_REQUEST_HEADER_SIZE"
fi
if [[ -v $WAITRESS_MAX_REQUEST_BODY_SIZE ]]; then
  params=" $params --max_request_body_size=$WAITRESS_MAX_REQUEST_BODY_SIZE"
fi
if [[ -v $WAITRESS_ASYNCORE_LOOP_TIMEOUT ]]; then
  params=" $params --asyncore_loop_timeout=$WAITRESS_ASYNCORE_LOOP_TIMEOUT"
fi
if [[ -v $WAITRESS_ASYNCORE_USE_POLL ]]; then
  params=" $params --asyncore_use_poll=$WAITRESS_ASYNCORE_USE_POLL"
fi

# Start Waitress
echo "waitress-serve $params $APP_MODULE"
exec waitress-serve $params $APP_MODULE
