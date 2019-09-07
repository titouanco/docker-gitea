ARG BUILD_ARCH=amd64

FROM $BUILD_ARCH/golang:1.13-alpine3.10 as builder

ARG GITEA_REPO=github.com/go-gitea/gitea
ARG GITEA_VERSION=master

RUN apk add --no-cache git make gcc libc-dev
RUN mkdir -p $GOPATH/src/code.gitea.io
RUN git clone --depth 1 --branch $GITEA_VERSION https://${GITEA_REPO}.git $GOPATH/src/code.gitea.io/gitea
RUN cd $GOPATH/src/code.gitea.io/gitea && TAGS="bindata sqlite sqlite_unlock_notify" make generate build

FROM $BUILD_ARCH/alpine:3.10
LABEL maintainer "Titouan Condé <hi+docker@titouan.co>"
LABEL org.label-schema.name="Gitea" \
      org.label-schema.vcs-url="https://code.titouan.co/titouan/docker-gitea"

ENV UID="991" \
    GID="991" \
    USER=git

COPY --from=builder /go/src/code.gitea.io/gitea/gitea /usr/local/bin/gitea
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN apk add --no-cache bash git openssh-client runit tini

VOLUME /data
EXPOSE 2222/tcp 3000/tcp

WORKDIR /data
CMD ["/sbin/tini","--","/usr/local/bin/start.sh"]
