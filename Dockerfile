FROM suchja/wine:dev1.7.38
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

ENV WINEDEBUG -all,err+all
#ENV WINEDLLOVERRIDES mscoree,mshtml=d

USER root
COPY waitonprocess.sh /scripts/
RUN chmod +x /scripts/waitonprocess.sh

USER xclient
# Install .NET Framework 4.0
RUN wine wineboot --init \
		&& /scripts/waitonprocess.sh wineserver \
		&& winetricks --unattended dotnet40 dotnet_verifier \
		&& /scripts/waitonprocess.sh wineserver
