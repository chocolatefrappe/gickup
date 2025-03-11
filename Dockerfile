ARG S6_OVERLAY_VERSION=v3.2.0.0
ARG GICKUP_VERSION=latest

FROM buddyspencer/gickup:${GICKUP_VERSION} AS gickup
FROM socheatsok78/s6-overlay-distribution:${S6_OVERLAY_VERSION} AS s6-overlay

FROM alpine:latest
COPY --link --from=gickup /gickup/gickup /usr/local/bin/gickup
ADD rootfs /
RUN apk add --no-cache \
    bash \
    curl \
    dumb-init \
    su-exec \
    tzdata
RUN <<EOF
    mkdir -p /var/lib/git
    addgroup -S -g 102 git
    adduser -S -D -G git -h /var/lib/git -u 102 git
    chown -R git:git /var/lib/git
EOF
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "gickup", "/etc/gickup.conf" ]
VOLUME [ "/data" ]
