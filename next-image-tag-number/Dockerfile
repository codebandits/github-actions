FROM alpine:latest
RUN apk add --update --no-cache --no-progress curl jq
COPY get-next-tag-number.sh /get-next-tag-number.sh
ENTRYPOINT ["/get-next-tag-number.sh"]
