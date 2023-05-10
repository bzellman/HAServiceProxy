ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install packages
RUN apk add --no-cache nginx jq

# Copy data for add-on
COPY run.sh /
COPY nginx.conf.tpl /
COPY services.sh /
RUN chmod a+x /run.sh /services.sh

CMD [ "/run.sh" ]
