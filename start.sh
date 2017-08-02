#!/bin/sh

addgroup -g ${GID} git
adduser -h /opt/data -s /bin/sh -D -G git -u ${UID} git

chown -R git:git /opt

chpst -u git -U git -- sh -c "HOME=/opt/data /opt/gitea/gitea web -c /opt/data/config.ini"
