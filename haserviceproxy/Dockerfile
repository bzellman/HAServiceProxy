ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk update && apk add --no-cache nginx jq

COPY nginx.conf.tpl /nginx.conf.tpl
COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]