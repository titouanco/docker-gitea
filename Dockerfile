ARG BUILD_ARCH=amd64
ARG BUILDER_GOLANG_VERSION=1.14-alpine3.12

FROM $BUILD_ARCH/golang:$BUILDER_GOLANG_VERSION as builder

ARG GITEA_REPO=github.com/go-gitea/gitea
ARG GITEA_VERSION=master

RUN apk add --no-cache build-base git nodejs npm
RUN mkdir -p $GOPATH/src/code.gitea.io
RUN git clone --depth 1 --branch $GITEA_VERSION https://${GITEA_REPO}.git $GOPATH/src/code.gitea.io/gitea
RUN cd $GOPATH/src/code.gitea.io/gitea && TAGS="bindata sqlite sqlite_unlock_notify" make clean-all build

FROM $BUILD_ARCH/alpine:3.12
LABEL maintainer "Titouan Condé <hi+docker@titouan.co>"
LABEL org.label-schema.name="Gitea" \
      org.label-schema.vcs-url="https://github.com/titouanco/docker-gitea"

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
