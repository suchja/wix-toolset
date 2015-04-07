FROM debian:wheezy
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Install wine
RUN apt-get update && apt-get install -y wine \
		&& rm -rf /var/lib/apt/lists/*
