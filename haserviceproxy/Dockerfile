FROM nginx:alpine

COPY run.sh /run.sh
COPY ssl /etc/nginx/ssl
COPY ui /usr/share/nginx/html

RUN apk add --no-cache jq
RUN chmod +x /run.sh

CMD ["/run.sh"]