FROM debian:wheezy
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Install wine
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends curl wine \
		&& rm -rf /var/lib/apt/lists/*

RUN curl -SL "https://wix.codeplex.com/downloads/get/1421697" -o /tmp/wix39-binaries.zip
