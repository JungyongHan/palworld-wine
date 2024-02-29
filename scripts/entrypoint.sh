#!/bin/sh

cat >/rcon.yaml  <<EOL
default:
  address: "127.0.0.1:${RCON_PORT}"
  password: "${ADMIN_PASSWORD}"
EOL

/usr/local/bin/supercronic -passthrough-logs /crontab &

chown -R $PUID:$PGID /app /backup

Xvfb :99 -screen 0 640x480x8 -nolisten tcp &

/gosu $PUID:$PGID /start.sh
