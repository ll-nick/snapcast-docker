FROM alpine AS server
RUN apk add --no-cache snapcast-server && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing snapweb
ENTRYPOINT ["snapserver"]

FROM alpine AS client
RUN apk add --no-cache snapcast-client
ENTRYPOINT ["snapclient"]

FROM client as client-pulseaudio
RUN apk add --no-cache pulseaudio
ENTRYPOINT ["snapclient", "--player", "pulse"]
