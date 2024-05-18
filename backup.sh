#!/bin/bash
DATE=$(date +%Y%m%d%H%M)
echo "=> Backup started at $(date "+%Y-%m-%d %H:%M:%S")"
FILENAME=/backup/archive.$DATE.tar.gz
LATEST=/backup/latest.tar.gz
tar -z "${GZIP_LEVEL}" cvf "$FILENAME" backuptarget/ 
echo "=> Backup finished at $(date "+%Y-%m-%d %H:%M:%S")"
echo "==> Creating symlink to latest backup: $(basename "$FILENAME".gz)"
rm "$LATEST" 2> /dev/null
cd /backup || exit && ln -s "$(basename "$FILENAME".tar.gz)" "$(basename "$LATEST")"

if [ -n "$MAX_BACKUPS" ]
then
  MAX_FILES=$(( MAX_BACKUPS ))
  while [ "$(find /backup -maxdepth 1 -name "*.tar.gz" -type f | wc -l)" -gt "$MAX_FILES" ]
  do
    TARGET=$(find /backup -maxdepth 1 -name "*.tar.gz" -type f | sort | head -n 1)
    echo "==> Max number of backups ($MAX_BACKUPS) reached. Deleting ${TARGET} ..."
    rm -rf "${TARGET}"
    echo "==> Backup ${TARGET} deleted"
  done
fi

echo "=> Backup process finished at $(date "+%Y-%m-%d %H:%M:%S")"
