# 🐳 eownis/gitea

[![build status](https://cd.code.titouan.co/api/badges/titouan/docker-gitea/status.svg)](https://cd.code.titouan.co/titouan/docker-gitea)

[![](https://images.microbadger.com/badges/version/eownis/gitea.svg)](https://microbadger.com/images/eownis/gitea "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/eownis/gitea.svg)](https://microbadger.com/images/eownis/gitea "Get your own image badge on microbadger.com") Based on the [master branch](https://github.com/go-gitea/gitea/tree/master) of Gitea

[![](https://images.microbadger.com/badges/version/eownis/gitea:v1.6.svg)](https://microbadger.com/images/eownis/gitea:v1.6 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/eownis/gitea:v1.6.svg)](https://microbadger.com/images/eownis/gitea:v1.6 "Get your own image badge on microbadger.com") Based on the [release/v1.6 branch](https://github.com/go-gitea/gitea/tree/release/v1.6) of Gitea

[![](https://images.microbadger.com/badges/version/eownis/gitea:v1.5.svg)](https://microbadger.com/images/eownis/gitea:v1.5 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/eownis/gitea:v1.5.svg)](https://microbadger.com/images/eownis/gitea:v1.5 "Get your own image badge on microbadger.com") Based on the [release/v1.5 branch](https://github.com/go-gitea/gitea/tree/release/v1.5) of Gitea

[Gitea](https://gitea.io). Built by [Drone](https://cd.code.titouan.co/titouan/docker-gitea) and pushed to [Docker Hub](https://hub.docker.com/r/eownis/gitea/).

## Usage

Extract from my `docker-compose.yml` file, adapt to your needs :

```yaml
...
  gitea:
    image: eownis/gitea:latest
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
