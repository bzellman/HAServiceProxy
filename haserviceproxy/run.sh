#!/bin/sh

# Get the SSL key and cert paths from the options
ssl_key_path="$(jq -r '.ssl_key_path' /data/options.json)"
ssl_cert_path="$(jq -r '.ssl_cert_path' /data/options.json)"



services="$(jq -c '.services[]' /data/options.json)"

# Generate location blocks for each internal service
location_blocks=""
for row in $services; do
  name=$(echo "$row" | jq -r '.name')
  ip_address=$(echo "$row" | jq -r '.ip_address')
  location_blocks="$location_blocks
  location /${name}/ {
    proxy_pass http://${ip_address};
    auth_request /auth;
  }"
done

# Generate nginx configuration file
cat << EOF > /etc/nginx/conf.d/default.conf
server {
  listen 80;

  location / {
    root /usr/share/nginx/html;
    index index.html;
  }

  location /api/ {
    proxy_pass http://192.168.0.206:443;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    auth_request /auth;
  }

  location = /auth {
    internal;
    proxy_pass http://192.168.0.206:443/api/hassio_auth;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
  }

  $location_blocks
}
EOF

# Start nginx
nginx -g 'daemon off;'