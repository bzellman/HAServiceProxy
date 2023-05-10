FROM nginx:alpine

COPY run.sh /run.sh
COPY ssl /etc/nginx/ssl
COPY ui /usr/share/nginx/html

RUN chmod +x /run.sh

CMD ["/run.sh"]