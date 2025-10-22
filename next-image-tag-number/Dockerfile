FROM alpine:latest
RUN apk add --update --no-cache --no-progress curl jq
COPY action.sh /action.sh
ENTRYPOINT ["/action.sh"]
