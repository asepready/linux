
```sh
podman pull ghcr.io/miniflux/miniflux:latest
podman pull docker.io/library/postgres:latest
podman pod create --name pod-miniflux -p 8080:8080
podman volume create miniflux-db

podman run --name=db -d --restart always --pod=pod-miniflux \
--volume=miniflux-db:/var/lib/postgresql/data \
-e POSTGRES_USER=dbadmin \
-e POSTGRES_PASSWORD=dbpasswd \
--health-start-period=30s \
--health-interval=10s \
--health-cmd="CMD-SHELL pg_isready -U miniflux" docker.io/library/postgres:latest

podman run --name=miniflux -d --restart=always --pod=pod-miniflux \
-e DATABASE_URL=postgres://<db-user>:<db-pass>@localhost/miniflux?sslmode=disable \
-e RUN_MIGRATIONS=1 \
-e CREATE_ADMIN=1 \
-e ADMIN_USERNAME=<admin-user> \
-e ADMIN_PASSWORD=<admin-pass> \
--health-cmd="CMD-SHELL /usr/bin/miniflux -healthcheck auto" ghcr.io/miniflux/miniflux:latest

# pod definition
podman generate kube pod-miniflux >> pod-miniflux.yaml

# systemd units
podman generate systemd \
--container-prefix pod-miniflux \
--pod-prefix minifluxpod \
--name pod-miniflux
