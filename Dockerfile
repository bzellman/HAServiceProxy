FROM homeassistant/armv7-addon-base:latest

RUN apk update && apk add --no-cache nginx jq

COPY nginx.conf.tpl /nginx.conf.tpl
COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]