events {
  worker_connections 1024;
}

http {
  include mime.types;

  server {
    listen 80;

    location / {
      return 301 https://$host$request_uri;
    }
  }

  server {
    listen 443 ssl;
    ssl_certificate {{ ssl_cert }};
    ssl_certificate_key {{ ssl_key }};

    {{ service_locations }}

    access_log /dev/stdout;
    error_log /dev/stdout {{ log_level }};
  }
}