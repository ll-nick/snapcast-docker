# Snapcast Docker

Dockerization of the great Snapcast library

## What's in here?

I utilize docker to easily deploy and manage Snapcast across multiple devices.
So in here you will find the Dockerfile used to create the [nickll/snapclient](https://hub.docker.com/r/nickll/snapclient) and [nickll/snapserver](https://hub.docker.com/r/nickll/snapserver) docker images.
The image will be built once a month for armv7, arm64 and amd64 architectures.

## Usage

I added example docker-compose files for both a client (alsa and pulseaudio based) and a server setup.
Adjust to your needs, here I'm using librespot to pipe Spotify to Snapcast.

Please note: The pulseaudio version is currently not functional as the installed binary has not been built with pulseaudio.

The snapserver.conf contains the server configuration.
See [here](https://github.com/badaix/snapcast/blob/master/server/etc/snapserver.conf) for additional documentation on this.
The server.json should be mounted so that the server has persistent knowledge about previously connected devices.
