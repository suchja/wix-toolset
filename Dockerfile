FROM suchja/wine:dev1.7.38
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# let wine not install wine-mono, because we will replace it with .NET 4.0 anyway
ENV WINEDLLOVERRIDES mscoree=d

# unfortunately we later need to wait on wineserver. Thus a small script for waiting is supplied.
USER root
COPY waitonprocess.sh /scripts/
RUN chmod +x /scripts/waitonprocess.sh

# Install .NET Framework 4.0
USER xclient
RUN wine wineboot --init \
		&& /scripts/waitonprocess.sh wineserver \
		&& winetricks --unattended dotnet40 dotnet_verifier \
		&& /scripts/waitonprocess.sh wineserver

# Install wix3.9 binaries
# Problem with downloading from codeplex. This downloads wix3.9RC4 which is exactly
# the same as wix 3.9 (see here: http://robmensching.com/blog/posts/2014/10/6/wix-v3.9-release-candidate-4/)
# TODO: Check what is required to build wix-binaries from source

RUN mkdir /home/wix/wix \
		&& cd /home/wix/wix \
		&& curl -SL "http://wixtoolset.org/downloads/v3.9.1006.0/wix39-binaries.zip" -o wix39-binaries.zip \
		&& unzip wix39-binaries.zip \
		&& rm -f wix39-binaries.zip
