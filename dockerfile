
# Build stage
FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod ./
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /bomberman .

# Runtime stage
FROM alpine:3.22

WORKDIR /app

COPY --from=builder /bomberman /app/bomberman
COPY index.html ./
COPY src ./src
COPY images ./images

RUN mkdir -p /data && chown -R 10001:10001 /app /data

USER 10001:10001

EXPOSE 8080

CMD ["/app/bomberman"]
