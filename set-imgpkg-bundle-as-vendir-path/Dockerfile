FROM alpine:latest
RUN apk add --update --no-cache --no-progress yq

# perl-utils: https://github.com/carvel-dev/ytt/issues/537
RUN apk add --update --no-cache --no-progress bash perl-utils \
    && wget -O- https://carvel.dev/install.sh | bash \
    && apk del bash perl-utils

COPY action.sh /action.sh
ENTRYPOINT ["/action.sh"]
