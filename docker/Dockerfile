FROM alpine as Build

RUN apk update && \
		apk add git && \
		mkdir -p /var/lib/leonardo/www
RUN git clone --depth=1 https://github.com/jolie/website.git /var/lib/leonardo/www
RUN rm -rf /var/lib/leonardo/www/docker /var/lib/leonardo/www/.git

# Start from scratch, copy the installer, install, remove the installer.
FROM jolielang/jolie
WORKDIR /
RUN mkdir -p /var/lib/leonardo/www
COPY --from=Build /var/lib/leonardo/www/www /var/lib/leonardo/www
COPY --from=Build /var/lib/leonardo/www/jolie /server

WORKDIR /server/leonardo

VOLUME /config

CMD ["jolie","leonardo.ol"]
