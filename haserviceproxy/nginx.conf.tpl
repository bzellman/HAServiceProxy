worker_processes  1;
error_log  /dev/stdout {{ log_level }};

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    ssl_certificate      {{ ssl_cert }};
    ssl_certificate_key  {{ ssl_key }};
    ssl_session_timeout  5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    server {
        listen 443 ssl http2 default_server;
        listen [::]:443 ssl http2 default_server;

        {{ service_locations }}

        location /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }
    }
}