#!/bin/sh

addgroup -g ${GID} git
adduser -h /data -s /bin/sh -D -G git -u ${UID} git

chown -R git:git /data

chpst -u git -U git -- sh -c "cd /data && HOME=/data GITEA_WORK_DIR=/data gitea web -c /data/config.ini"
