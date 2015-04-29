FROM suchja/wine:dev1.7.38
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

ENV WINEDEBUG -all,err+all
#ENV WINEDLLOVERRIDES mscoree,mshtml=d

USER root
COPY waitonallprocesses.sh /scripts/
RUN chmod +x /scripts/waitonallprocesses.sh

USER xclient
# Install .NET Framework 4.0
RUN (wine wineboot --init & wait) \
		&& /scripts/waitonallprocesses.sh \
		&& ps aux	
