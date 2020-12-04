# 🐳 `titouanco/gitea`

[Gitea](https://gitea.io). Built by [GitHub Actions](https://github.com/titouanco/docker-gitea/actions) and pushed to [Docker Hub](https://hub.docker.com/r/titouanco/gitea/).

## Tags available

- Built everyday at ~2:00 UTC:
  - `latest` : Based on the [master branch](https://github.com/go-gitea/gitea/tree/master) of Gitea
  - `v1.13` : Based on the [release/v1.13 branch](https://github.com/go-gitea/gitea/tree/release/v1.13) of Gitea
  - `v1.12` : Based on the [release/v1.12 branch](https://github.com/go-gitea/gitea/tree/release/v1.12) of Gitea
- Not built anymore:
  - `v1.11` : Based on the [release/v1.11 branch](https://github.com/go-gitea/gitea/tree/release/v1.11) of Gitea
  - `v1.10` : Based on the [release/v1.10 branch](https://github.com/go-gitea/gitea/tree/release/v1.10) of Gitea
  - `v1.9` : Based on the [release/v1.9 branch](https://github.com/go-gitea/gitea/tree/release/v1.9) of Gitea
  - `v1.8` : Based on the [release/v1.8 branch](https://github.com/go-gitea/gitea/tree/release/v1.8) of Gitea
  - `v1.7` : Based on the [release/v1.7 branch](https://github.com/go-gitea/gitea/tree/release/v1.7) of Gitea

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
