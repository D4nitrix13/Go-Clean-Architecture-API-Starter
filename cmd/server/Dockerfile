FROM golang:alpine AS build
RUN apk update && \
    apk add curl \
    git \
    bash \
    make \
    ca-certificates && \
    rm -rf /var/cache/apk/*

# Install migrate which will be used by entrypoint.sh to perform DB migration
ARG MIGRATE_VERSION=4.7.1
ADD https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.linux-amd64.tar.gz /tmp
RUN /bin/tar -xzf /tmp/migrate.linux-amd64.tar.gz -C /usr/local/bin && /bin/mv /usr/local/bin/migrate.linux-amd64 /usr/local/bin/migrate

WORKDIR /app

# Copy module files first so that they don't need to be downloaded again if no change
COPY ./go.* ./
RUN /go mod download
RUN /go mod verify

# Copy source files and build the binary
COPY . .
RUN /bin/make build

# Final stage
FROM alpine:latest

ARG USERNAME=d4nitrix13
RUN /bin/apk --no-cache add ca-certificates bash
RUN /bin/mkdir -p /var/log/app
WORKDIR /app/
COPY --chown=${USERNAME}:${USERNAME} --from=build /usr/local/bin/migrate /usr/local/bin
COPY --chown=${USERNAME}:${USERNAME} --from=build /app/migrations ./migrations/
COPY --chown=${USERNAME}:${USERNAME} --from=build /app/server .
COPY --chown=${USERNAME}:${USERNAME} --from=build /app/cmd/server/entrypoint.sh .
COPY --chown=${USERNAME}:${USERNAME} --from=build /app/config/*.yml ./config/
RUN /bin/chown -R ${USERNAME}:${USERNAME} .
USER ${USERNAME}

ENTRYPOINT [ "./entrypoint.sh" ]