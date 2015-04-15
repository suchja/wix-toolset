FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Inspired by monokrome/wine and justmoon/docker-wix

# first create user and group for all the X Window stuff
# required to do this first so have consistent uid/gid between server and client container
RUN addgroup --system xusers \
  && adduser \
			--home /home/wix \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for wix toolset" \
			--ingroup xusers \
			--quiet \
			wix

# winetricks is located in the contrib repository
RUN echo "deb http://http.debian.net/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list

# Install wine and related packages
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends \
				curl \
				unzip \
				msttcorefonts \
				wine \
				wine32 \
				xauth \
		&& rm -rf /var/lib/apt/lists/*

# Use the latest version of winetricks
RUN curl -SL 'http://winetricks.org/winetricks' -o /usr/local/bin/winetricks \
		&& chmod +x /usr/local/bin/winetricks

# Wine really doesn't like to be run as root, so let's use a non-root user
USER wix
ENV HOME /home/wix
ENV WINEPREFIX /home/wix/.wine
ENV WINEARCH win32

# Install .NET Framework 4.0
WORKDIR /home/wix
RUN wine wineboot && winetricks --unattended dotnet40

# Install wix3.9 binaries
# Problem with downloading from codeplex. This downloads wix3.9RC4 which is exactly
# the same as wix 3.9 (see here: http://robmensching.com/blog/posts/2014/10/6/wix-v3.9-release-candidate-4/)
# TODO: Check what is required to build wix-binaries from source

RUN mkdir /home/wix/wix \
		&& cd /home/wix/wix \
		&& curl -SL "http://wixtoolset.org/downloads/v3.9.1006.0/wix39-binaries.zip" -o wix39-binaries.zip \
		&& unzip wix39-binaries.zip \
		&& rm -f wix39-binaries.zip

# During startup we need to prepare connection to X11-Server container
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]