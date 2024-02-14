#!/bin/sh
mkdir -p /app/.cache
chown -R $PUID:$PGID .cache

crond -f &

Xvfb :99 -screen 0 640x480x8 -nolisten tcp &

/gosu $PUID:$PGID /start.sh
