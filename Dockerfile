FROM alpine:latest
ARG TARGETARCH

EXPOSE 8384 22000/tcp 22000/udp 21027/udp

VOLUME ["/config"]
VOLUME ["/data"]

RUN apk add --no-cache ca-certificates su-exec tzdata

COPY ./syncthing /bin/syncthing
COPY ./entrypoint.sh /bin/entrypoint.sh

ENV PUID=1000 PGID=1000 HOME=/var/syncthing

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z 127.0.0.1 8384 || exit 1

ENV STGUIADDRESS=0.0.0.0:8384
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/syncthing", "-home", "/config"]
