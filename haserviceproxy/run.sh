#!/bin/sh

# Get the SSL key and cert paths from the options
ssl_key_path="$(jq -r '.ssl_key_path' /data/options.json)"
ssl_cert_path="$(jq -r '.ssl_cert_path' /data/options.json)"

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

  # Add locations for each internal service
  $(for service in "${!services[@]}"; do
    echo "location /${services[$service]["name"]}/ {";
    echo "  proxy_pass http://${services[$service]["ip_address"]};";
    echo "  auth_request /auth;";
    echo "}";
  done)
}
EOF

# Start nginx
nginx -g 'daemon off;'