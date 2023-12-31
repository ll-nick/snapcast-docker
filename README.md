# Snapcast Docker

Dockerization of the great Snapcast library

## What's in here?

I utilize docker to easily deploy and manage Snapcast across multiple devices.
So in here you will find the Dockerfile used to create the [nickll/snapclient](https://hub.docker.com/r/nickll/snapclient) and [nickll/snapserver](https://hub.docker.com/r/nickll/snapserver) docker images.
I use GitHub action to check for new Snapcast releases on a daily basis.
If there is a new release, a new docker image will be built automatically for armv7, arm64 and amd64 architectures.

I use alpine as a base image and work with a multistage docker build to keep the image size minimal.

## Usage

I added example docker-compose files for both a client (alsa and pulseaudio based) and a server setup.
Adjust to your needs, here I'm using librespot to pipe Spotify to Snapcast.
Make sure to configure the variables in the .env file.

The snapserver.conf contains the server configuration.
See [here](https://github.com/badaix/snapcast/blob/master/server/etc/snapserver.conf) for additional documentation on this.
The server.json should be mounted so that the server has persistent knowledge about previously connected devices.
