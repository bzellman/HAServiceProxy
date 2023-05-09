#!/usr/bin/with-contenv bash

# Set up the environment
export SERVICES="$(jq --raw-output '.services | @base64' /data/options.json)"
export SIDEBAR_SERVICES="$(jq --raw-output '.sidebar_services | @base64' /data/options.json)"
export SSL_CERT="$(jq --raw-output '.ssl_cert' /data/options.json)"
export SSL_KEY="$(jq --raw-output '.ssl_key' /data/options.json)"
export LOG_LEVEL="$(jq --raw-output '.log_level' /data/options.json)"

# Generate nginx location blocks for services
...
# Replace the placeholder in the nginx.conf template
sed "s|{{ service_locations }}|$SERVICE_LOCATIONS|" nginx.conf.tpl > /etc/nginx/nginx.conf

# Configure SSL paths and logging level for nginx
sed -i "s|ssl_certificate .*|ssl_certificate $SSL_CERT;|" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate_key .*|ssl_certificate_key $SSL_KEY;|" /etc/nginx/nginx.conf
sed -i "s/error_log .*/error_log \/dev\/stdout $LOG_LEVEL;/" /etc/nginx/nginx.conf

# Start the add-on
exec nginx -g "daemon off;"