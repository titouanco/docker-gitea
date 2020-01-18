# 🐳 titouanco/gitea

[![build status](https://cd.code.titouan.co/api/badges/titouan/docker-gitea/status.svg)](https://cd.code.titouan.co/titouan/docker-gitea)

[![](https://images.microbadger.com/badges/version/titouanco/gitea.svg)](https://microbadger.com/images/titouanco/gitea "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/titouanco/gitea.svg)](https://microbadger.com/images/titouanco/gitea "Get your own image badge on microbadger.com") Based on the [master branch](https://github.com/go-gitea/gitea/tree/master) of Gitea

[![](https://images.microbadger.com/badges/version/titouanco/gitea:v1.11.svg)](https://microbadger.com/images/titouanco/gitea:v1.11 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/titouanco/gitea:v1.11.svg)](https://microbadger.com/images/titouanco/gitea:v1.11 "Get your own image badge on microbadger.com") Based on the [release/v1.11 branch](https://github.com/go-gitea/gitea/tree/release/v1.11) of Gitea

[![](https://images.microbadger.com/badges/version/titouanco/gitea:v1.10.svg)](https://microbadger.com/images/titouanco/gitea:v1.10 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/titouanco/gitea:v1.10.svg)](https://microbadger.com/images/titouanco/gitea:v1.10 "Get your own image badge on microbadger.com") Based on the [release/v1.10 branch](https://github.com/go-gitea/gitea/tree/release/v1.10) of Gitea

[Gitea](https://gitea.io). Built by [Drone](https://cd.code.titouan.co/titouan/docker-gitea) and pushed to [Docker Hub](https://hub.docker.com/r/titouanco/gitea/).

## Usage

Extract from my `docker-compose.yml` file, adapt to your needs :

```yaml
...
  gitea:
    image: titouanco/gitea:latest
    container_name: gitea
    restart: always
    ports:
      - "22:2222/tcp"
    volumes:
      - ./gitea:/data
    environment:
      - UID=1000
      - GID=1000
...
```

If you use a `docker-compose.yml` file you can pretty much copy paste the snippet and add gitea to your reverse proxy (the web interface is listening on port 3000)
