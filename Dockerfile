FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download && CGO_ENABLED=0 GOOS=linux go build -o bot ./src/bot.go

FROM alpine:3.20.3
LABEL org.opencontainers.image.source=https://github.com/pablon/bot
WORKDIR /app
COPY ./proto/ ./proto/
COPY --from=builder /app/bot ./
RUN adduser -h /app -H -s /sbin/nologin -D -u 10000 bot-user && chown -R bot-user:bot-user /app
USER bot-user
EXPOSE 3001
CMD [ "./bot", "-bn=bot", "-la=bot:3001", "-gs=game:50051" ]
