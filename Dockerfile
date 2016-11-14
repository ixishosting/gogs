FROM alpine:3.4

# Install system utils & Gogs runtime dependencies
ADD https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 /usr/sbin/gosu
RUN chmod +x /usr/sbin/gosu \
 && apk --update --no-cache --no-progress add ca-certificates bash git linux-pam s6 curl openssh socat ansible \
 && apk add --no-cache gogs --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

ENV GOGS_CUSTOM /data/gogs

RUN mkdir /app/gogs
WORKDIR /app/gogs/

RUN adduser -H -D -g 'Gogs Git User' git -h /data/git -s /bin/bash && passwd -u git
RUN echo "export GOGS_CUSTOM=${GOGS_CUSTOM}" >> /etc/profile
RUN ln -s /usr/share/webapps/gogs/public /app/gogs/
RUN ln -s /usr/share/webapps/gogs/templates /app/gogs/

# Configure LibC Name Service
COPY docker/nsswitch.conf /etc/nsswitch.conf

# Configure Docker Container
VOLUME ["/data"]
EXPOSE 22 3000
ENTRYPOINT ["docker/start.sh"]
CMD ["/bin/s6-svscan", "/app/gogs/docker/s6/"]
