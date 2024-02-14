#!/bin/bash
DATE=`date +%Y%m%d%H`
PALDIR="/app/steamapps/common/PalServer/Pal"

# Backup Binaries and Saved directories.
# We save Binaries because most mods their configs live there.
tar -zcvf /backup/palworld-${DATE}.tgz ${PALDIR}/Saved ${PALDIR}/Binaries

# Only keep 10 backups
ls -d -1tr /backup/* | head -n -10 | xargs -d '\n' rm -f
