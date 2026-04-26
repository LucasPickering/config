FROM alpine:latest

RUN apk --no-cache add transmission-daemon
ADD settings.json /root/.config/transmission-daemon/settings.json

CMD ["transmission-daemon", "-f", "--log-error"]
