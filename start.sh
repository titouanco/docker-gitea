#!/bin/sh

addgroup -g ${GID} git
adduser -h /data -s /bin/sh -D -G git -u ${UID} git

chown -R git:git /data

if ! [ -f "/data/config.ini" ]; then

SETUP_LFS_JWT_SECRET=$(gitea generate secret LFS_JWT_SECRET)
SETUP_SECRET_KEY=$(gitea generate secret SECRET_KEY)
SETUP_INTERNAL_TOKEN=$(gitea generate secret INTERNAL_TOKEN)

cat > /data/config.ini <<__EOF__
APP_NAME = Gitea
RUN_USER = git
RUN_MODE = prod

[repository]
ROOT = /data/gitea-repositories

[ui]
DEFAULT_THEME = default

[server]
SSH_DOMAIN       = replace-me
DOMAIN           = replace-me
HTTP_PORT        = 3000
ROOT_URL         = https://replace-me/
DISABLE_SSH      = false
START_SSH_SERVER = true
SSH_PORT         = 22
SSH_LISTEN_PORT  = 2222
LFS_START_SERVER = true
LFS_CONTENT_PATH = /data/lfs
LFS_JWT_SECRET   = ${SETUP_LFS_JWT_SECRET}
OFFLINE_MODE     = false

[database]
DB_TYPE  = postgres
HOST     = replace-me:5432
NAME     = gitea
USER     = gitea
PASSWD   = replace-me
SSL_MODE = disable

[indexer]
ISSUE_INDEXER_PATH   = /data/indexers/issues.bleve
REPO_INDEXER_ENABLED = true
REPO_INDEXER_PATH    = /data/indexers/repos.bleve

[security]
INSTALL_LOCK   = true
SECRET_KEY     = ${SETUP_SECRET_KEY}
INTERNAL_TOKEN = ${SETUP_INTERNAL_TOKEN}

[openid]
ENABLE_OPENID_SIGNIN = true
ENABLE_OPENID_SIGNUP = true

[service]
REGISTER_EMAIL_CONFIRM            = true
DISABLE_REGISTRATION              = false
REQUIRE_SIGNIN_VIEW               = false
ENABLE_NOTIFY_MAIL                = true
DEFAULT_KEEP_EMAIL_PRIVATE        = false
NO_REPLY_ADDRESS                  = noreply.replace-me
ENABLE_CAPTCHA                    = true
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING       = true

[mailer]
ENABLED = true
HOST    = replace-me
FROM    = replace-me
USER    = replace-me
PASSWD  = replace-me

[session]
PROVIDER        = file
PROVIDER_CONFIG = /data/sessions
COOKIE_SECURE   = true

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false
AVATAR_UPLOAD_PATH      = /data/avatars

[attachment]
ENABLED  = true
PATH     = /data/attachment
MAX_SIZE = 10

[log]
ROOT_PATH = /data/log
MODE      = file
LEVEL     = Info
__EOF__

fi

chpst -u git -U git -- sh -c "cd /data && HOME=/data GITEA_WORK_DIR=/data gitea web -c /data/config.ini"
