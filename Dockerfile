#
# Dockerfile for openconnect-arm
#

FROM arm32v7/alpine:latest

RUN set -xe \
    && apk add --no-cache nettle \
    && apk add --no-cache \
               --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
               openconnect \
    && mkdir -p /etc/openconnect \
    && touch /etc/openconnect/openconnect.conf


COPY scripts/connect.sh /root
RUN chmod +x /root/connect.sh

HEALTHCHECK --start-period=15s --retries=1 \
  CMD pgrep openconnect || exit 1; pgrep dnsmasq || exit 1

CMD ["sh" , "-c", "sh /root/connect.sh -D && ip addr && sh && tail -f /dev/null"]

