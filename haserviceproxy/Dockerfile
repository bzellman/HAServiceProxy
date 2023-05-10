FROM nginx:alpine

RUN apk add --no-cache jq

COPY run.sh /run.sh
COPY ui /usr/share/nginx/html


RUN chmod +x /run.sh

CMD ["/run.sh"]