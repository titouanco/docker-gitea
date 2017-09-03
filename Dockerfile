LABEL maintainer "Titouan Condé <eownis+docker@titouan.co>"
LABEL org.label-schema.name="Gitea" \
      org.label-schema.vcs-url="https://git.titouan.co/eownis/docker-gitea"

FROM golang:1.9-alpine3.6 as builder

ARG GITEA_VERSION=master

RUN apk add --no-cache git make gcc libc-dev
RUN mkdir -p $GOPATH/src/code.gitea.io
RUN git clone --depth 1 --branch $GITEA_VERSION https://github.com/go-gitea/gitea.git $GOPATH/src/code.gitea.io/gitea
RUN cd $GOPATH/src/code.gitea.io/gitea && TAGS="sqlite bindata" make generate build

FROM alpine:3.6

ENV UID="991" \
    GID="991" \
    USER=git

COPY --from=builder /go/src/code.gitea.io/gitea/gitea/ /opt/gitea/
COPY start.sh /usr/bin/start.sh

RUN apk add --no-cache bash git openssh-client runit tini
RUN chmod +x /usr/bin/start.sh

VOLUME /opt/data
EXPOSE 2222 3000

WORKDIR /opt/data
CMD ["/sbin/tini","--","/usr/bin/start.sh"]
