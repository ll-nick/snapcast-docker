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
# Todo: Remove cherry-pick hotfix with new version, see: https://github.com/badaix/snapcast/pull/1124
RUN git clone https://github.com/badaix/snapcast.git && \
    LATEST_TAG=$(git -C snapcast describe --tags $(git -C snapcast rev-list --tags --max-count=1)) && \
    git -C snapcast checkout $LATEST_TAG && \
    git -C snapcast cherry-pick 481f08199ca31c60c9a3475f1064e6b06a503d12 && \
    cd /snapcast && \
    make && \
    cd /snapcast/server && \
    make installfiles && \
    cd /snapcast/client && \
    make installfiles

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
COPY --from=build /usr/bin/snapserver /usr/bin/snapserver
COPY --from=build /usr/share/snapserver /usr/share/snapserver
ENTRYPOINT ["snapserver"]

FROM base as client
COPY --from=build /usr/bin/snapclient /usr/bin/snapclient
ENTRYPOINT ["snapclient"]

FROM client as client-pulseaudio
RUN apk add --no-cache pulseaudio
ENTRYPOINT ["snapclient", "--player", "pulse"]
