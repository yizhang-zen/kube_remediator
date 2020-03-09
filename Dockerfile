# build
FROM golang:1.12-alpine AS builder

WORKDIR /app
COPY . .
RUN apk update && apk add --no-cache git ca-certificates

# vendor first so we fail when a dependency is missing and do not install random versions
RUN CGO_ENABLED=0 GOOS=linux go build -o /remediator cmd/remediator/app.go

# pack
FROM alpine

WORKDIR .

ADD config config

COPY --from=builder /remediator .

CMD ["./remediator"]
