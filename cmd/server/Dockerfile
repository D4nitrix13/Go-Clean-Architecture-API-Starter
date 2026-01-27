# ============================
# Build stage: compile Go app
# ============================
FROM golang:alpine AS build

# Install build tools and dependencies
RUN /sbin/apk update && \
    /sbin/apk add --no-cache curl git make ca-certificates && \
    /bin/rm -rf /var/cache/apk/*

WORKDIR /app

# Copy go.mod and go.sum first to leverage Docker layer caching
COPY ./go.* ./
RUN /usr/local/go/bin/go mod download
RUN /usr/local/go/bin/go mod verify

# Copy source code and build the binary
COPY . .
RUN /usr/local/go/bin/go build -o server ./cmd/server

# ============================
# Final stage: runtime image
# ============================
FROM alpine:latest

ARG USERNAME=d4nitrix13

# Create user and log directory
# En Alpine, 'adduser' está en el PATH
RUN adduser -D -g "" ${USERNAME} && /bin/mkdir -p /var/log/app

WORKDIR /app/

# Copy only the binary and config
COPY --from=build /app/server .
COPY --from=build /app/config/*.yml ./config/

# Adjust ownership
RUN /bin/chown -R ${USERNAME}:${USERNAME} .

USER ${USERNAME}

# Document port
EXPOSE 8080

# Run the Go server when the container starts
CMD ["/app/server"]
