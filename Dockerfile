FROM suchja/wine:dev1.7.38
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

ENV WINEARCH win32

# Install .NET Framework 4.0
WORKDIR /home/xclient
RUN wine wineboot --update && winetricks --unattended dotnet40

#	Maybe GAC needs to be updated, but it will exit with error code. How to ignore it in Docker?
# wine "c:\\windows\\Microsoft.NET\\Framework\\v4.0.30319\\ngen.exe" update

# Install wix3.9 binaries
# Problem with downloading from codeplex. This downloads wix3.9RC4 which is exactly
# the same as wix 3.9 (see here: http://robmensching.com/blog/posts/2014/10/6/wix-v3.9-release-candidate-4/)
# TODO: Check what is required to build wix-binaries from source

RUN mkdir /home/xclient/wix \
		&& cd /home/xclient/wix \
		&& curl -SL "http://wixtoolset.org/downloads/v3.9.1006.0/wix39-binaries.zip" -o wix39-binaries.zip \
		&& unzip wix39-binaries.zip \
		&& rm -f wix39-binaries.zip
