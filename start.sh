#!/bin/sh

addgroup -g ${GID} git
adduser -h /data -s /bin/sh -D -G git -u ${UID} git

chown -R git:git /data

chpst -u git -U git -- sh -c "HOME=/data gitea web -c /data/config.ini"
