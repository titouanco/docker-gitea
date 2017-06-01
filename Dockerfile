FROM alpine:3.6
LABEL maintainer "Titouan Condé <eownis+docker@titouan.co>"
LABEL org.label-schema.vcs-url="https://gitlab.com/eownis/docker-gitea"

ARG GOLANG_VERSION=1.8.3
ARG GOLANG_DOWNLOAD_SHA256=5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6
ARG GITEA_VERSION=master

ENV UID="991" \
    GID="991" \
    USER=git

# https://golang.org/issue/14851
COPY no-pic.patch /
COPY start.sh /usr/bin/start.sh

RUN buildDeps='gcc go libc-dev make musl-dev openssl' \
    && apk add --no-cache $buildDeps bash git go openssh-client runit tini \
    # Install golang
    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && cd /tmp \
    && wget -O golang.tar.gz https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && cd /usr/local/go/src \
    && patch -p2 -i /no-pic.patch \
    && ./make.bash \
    && export GOPATH=/tmp/go \
    && export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH \
    # Install Gitea
    && mkdir -p $GOPATH/src/code.gitea.io \
    && cd $GOPATH/src/code.gitea.io \
    && git clone --depth 1 --branch $GITEA_VERSION https://github.com/go-gitea/gitea.git \
    && cd $GOPATH/src/code.gitea.io/gitea \
    && TAGS="sqlite bindata" make generate build \
    && mkdir -p /opt/gitea/ \
    && mv $GOPATH/src/code.gitea.io/gitea/gitea /opt/gitea/ \
    # Cleaning
    && rm -rf /usr/local/go \
    && rm -rf /tmp/* \
    && rm -rf /no-pic.patch \
    && apk del $buildDeps \
    # Preparing start.sh
    && chmod +x /usr/bin/start.sh

VOLUME /opt/data
EXPOSE 2222 3000

WORKDIR /opt/data
CMD ["/sbin/tini","--","/usr/bin/start.sh"]
