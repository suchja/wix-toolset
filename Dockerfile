FROM wine:debug
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

ENV WINEDEBUG err+all
ENV WINEDLLOVERRIDES mscoree,mshtml=d

# Install .NET Framework 4.0
RUN wine wineboot --init && winetricks --unattended dotnet40 dotnet_verifier
