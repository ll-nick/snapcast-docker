FROM alpine AS build

# Install dependencies
RUN apk add --no-cache \
    alsa-lib-dev \
    avahi-dev \
    bash \
    boost-dev \
    build-base \
    flac-dev \
    git \
    libvorbis-dev \
    linux-headers \
    opus-dev \
    pulseaudio-dev \
    soxr-dev

# Clone the Snapcast repository and most recent tag
RUN git clone --depth 1 https://github.com/badaix/snapcast.git && \
    LATEST_TAG=$(git -C snapcast describe --tags $(git -C snapcast rev-list --tags --max-count=1)) && \
    git -C snapcast checkout $LATEST_TAG && \
    cd snapcast && \
    make && \
    strip server/snapserver client/snapclient && \
    chmod -R 644 server/etc/snapweb

FROM alpine as base

# Install runtime dependencies
RUN apk add --no-cache \
    alsa-lib \
    avahi-libs \
    flac \
    libogg \
    libpulse \
    libvorbis \
    opus \
    soxr

FROM base as server
COPY --from=build --chown=root:root /snapcast/server/snapserver /usr/bin/snapserver
COPY --from=build --chown=root:root /snapcast/server/snapserver.1 /usr/share/man/man1/snapserver.1
COPY --from=build --chown=root:root /snapcast/server/etc/index.php /snapcast/server/etc/snapweb /usr/share/snapserver/

# Run server
ENTRYPOINT ["snapserver"]


FROM base as client
COPY --from=build --chown=root:root /snapcast/client/snapclient /usr/bin/snapclient
COPY --from=build --chown=root:root /snapcast/client/snapclient.1 /usr/share/man/man1/snapclient.1

# Run client
ENTRYPOINT ["snapclient"]
