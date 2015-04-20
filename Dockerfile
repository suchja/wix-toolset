FROM suchja/wine:latest
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Install .NET Framework 4.0
WORKDIR /home/xclient
RUN wine wineboot && winetricks --unattended dotnet40

# Install wix3.9 binaries
# Problem with downloading from codeplex. This downloads wix3.9RC4 which is exactly
# the same as wix 3.9 (see here: http://robmensching.com/blog/posts/2014/10/6/wix-v3.9-release-candidate-4/)
# TODO: Check what is required to build wix-binaries from source

RUN mkdir /home/xclient/wix \
		&& cd /home/xclient/wix \
		&& curl -SL "http://wixtoolset.org/downloads/v3.9.1006.0/wix39-binaries.zip" -o wix39-binaries.zip \
		&& unzip wix39-binaries.zip \
		&& rm -f wix39-binaries.zip
