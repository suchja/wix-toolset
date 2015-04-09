FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# winetricks is located in the contrib repository
RUN echo "deb http://http.debian.net/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list

# Install wine and related packagesRUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends \
				curl \
				wine \
				winetricks \
				xvfb \
		&& rm -rf /var/lib/apt/lists/*

# Problem with downloading from codeplex. This downloads wix3.9RC4 which is exactly
# the same as wix 3.9 (see here: http://robmensching.com/blog/posts/2014/10/6/wix-v3.9-release-candidate-4/)
# TODO: Check what is required to build wix-binaries from source
RUN curl -SL "http://wixtoolset.org/downloads/v3.9.1006.0/wix39-binaries.zip" -o /tmp/wix39-binaries.zip
