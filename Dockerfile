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
    make

FROM alpine as base

# Copy Snapcast from the build stage
COPY --from=build /snapcast/server/snapserver /snapcast/client/snapclient /usr/bin/

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

# Run server
ENTRYPOINT ["snapserver"]


FROM base as client

# Run client
ENTRYPOINT ["snapclient"]