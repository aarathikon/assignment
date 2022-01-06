FROM golang:alpine as int-builder

LABEL  Aarathi <aarthidevops97@gmail.com>

ADD go.mod main.go /mnt/
WORKDIR /mnt/
RUN go build -o go-webapp .

FROM alpine
COPY --from=int-builder /mnt/go-webapp .
RUN addgroup -S go-grp && adduser -S go-usr -G go-grp
USER go-usr
HEALTHCHECK  --interval=1m --timeout=30s \
  CMD wget --no-verbose --tries=4 --spider http://localhost:3030/health || exit 1
CMD [ "./go-webapp" ]
