FROM golang:1.9-alpine3.7 as builder

ARG GITEA_VERSION=master

RUN apk add --no-cache git make gcc libc-dev
RUN mkdir -p $GOPATH/src/code.gitea.io
RUN git clone --depth 1 --branch $GITEA_VERSION https://github.com/go-gitea/gitea.git $GOPATH/src/code.gitea.io/gitea
RUN cd $GOPATH/src/code.gitea.io/gitea && TAGS="sqlite bindata" make generate build

FROM alpine:3.7
LABEL maintainer "Titouan Condé <eownis+docker@titouan.co>"
LABEL org.label-schema.name="Gitea" \
      org.label-schema.vcs-url="https://git.titouan.co/eownis/docker-gitea"

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
