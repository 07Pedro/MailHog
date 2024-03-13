FROM golang:1.21-alpine as builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Set Golang build envs based on Docker platform string
RUN go mod vendor
RUN go build -o MailHog  ./

FROM alpine:3.18
WORKDIR /app

COPY --from=builder /app/MailHog /usr/local/bin/mailhog

EXPOSE 1025 8025

CMD ["mailhog"]