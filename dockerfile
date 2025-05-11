
FROM golang:1.23.4-alpine AS builder

RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download -x

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s" -o /app/parcel-tracker .

FROM alpine:3.18

RUN apk add --no-cache tzdata ca-certificates
WORKDIR /app
COPY --from=builder /app/parcel-tracker /app/
COPY --from=builder /app/tracker.db /app/

EXPOSE 8080
CMD ["/app/parcel-tracker"]