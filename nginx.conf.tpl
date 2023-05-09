events {
  worker_connections 1024;
}

http {
  server {
    listen 8080 ssl;
    ssl_certificate /ssl/fullchain.pem;
    ssl_certificate_key /ssl/privkey.pem;

    location / {
      return 403;
    }

    {{ service_locations }}
  }
}