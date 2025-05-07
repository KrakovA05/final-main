# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/parcel-tracker

# Runtime stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/parcel-tracker /app/parcel-tracker
COPY --from=builder /app/tracker.db /app/tracker.db
EXPOSE 8080
CMD ["/app/parcel-tracker"]