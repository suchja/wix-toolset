FROM debian:wheezy
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Install wine
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends wine \
		&& rm -rf /var/lib/apt/lists/*
