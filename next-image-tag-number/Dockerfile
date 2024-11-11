FROM alpine:latest
RUN apk add --update --no-cache --no-progress curl jq
RUN adduser -u 1001 -D action
USER action
COPY action.sh /action.sh
ENTRYPOINT ["/action.sh"]
