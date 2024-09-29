FROM alpine AS server
RUN apk add --no-cache snapcast-server
ENTRYPOINT ["snapserver"]

FROM alpine AS client
RUN apk add --no-cache snapcast-client
ENTRYPOINT ["snapclient"]

FROM client as client-pulseaudio
RUN apk add --no-cache pulseaudio
ENTRYPOINT ["snapclient", "--player", "pulse"]
