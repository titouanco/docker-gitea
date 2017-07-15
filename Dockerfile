FROM alpine:3.6 as builder
LABEL maintainer "Titouan Condé <eownis+docker@titouan.co>"
LABEL org.label-schema.vcs-url="https://gitlab.com/eownis/docker-gitea"

ARG GOLANG_VERSION=1.8.3
ARG GOLANG_DOWNLOAD_SHA256=5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6
ARG GITEA_VERSION=master

# Check the official Dockerfile https://hub.docker.com/_/golang/
ARG GOLANG_NOPIC_PATCH=https://raw.githubusercontent.com/docker-library/golang/495a742832974d434c6e3356e19c93b0e82543c8/1.8/alpine3.6/no-pic.patch

# Install build dependencies
RUN apk add --no-cache gcc go libc-dev make musl-dev openssl bash git
RUN wget -O /no-pic.patch $GOLANG_NOPIC_PATCH
# Download Golang
RUN wget -O /tmp/golang.tar.gz https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
RUN cd /tmp && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c -
RUN tar -C /usr/local -xzf /tmp/golang.tar.gz
# Make Golang
RUN export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && cd /usr/local/go/src \
    && patch -p2 -i /no-pic.patch \
    && ./make.bash
# Make Gitea
RUN export GOROOT=/usr/local/go \
    && export GOPATH=/tmp/go \
    && export PATH=$GOROOT/bin:$GOPATH/bin:$PATH \
    && mkdir -p $GOPATH/src/code.gitea.io \
    && git clone --depth 1 --branch $GITEA_VERSION https://github.com/go-gitea/gitea.git $GOPATH/src/code.gitea.io/gitea \
    && cd $GOPATH/src/code.gitea.io/gitea \
    && TAGS="sqlite bindata" make generate build

FROM alpine:3.6

ENV UID="991" \
    GID="991" \
    USER=git

COPY --from=builder /tmp/go/src/code.gitea.io/gitea/gitea/ /opt/gitea/
COPY start.sh /usr/bin/start.sh

RUN apk add --no-cache bash git openssh-client runit tini
RUN chmod +x /usr/bin/start.sh

VOLUME /opt/data
EXPOSE 2222 3000

WORKDIR /opt/data
CMD ["/sbin/tini","--","/usr/bin/start.sh"]
