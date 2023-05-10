#!/bin/sh

# Read options from the configuration file
. /services.sh
SERVICES="$(jq --raw-output '.services | @base64' /data/options.json)"
SIDEBAR_SERVICES="$(jq --raw-output '.sidebar_services | @base64' /data/options.json)"
SSL_CERT="$(jq --raw-output '.ssl_cert' /data/options.json)"
SSL_KEY="$(jq --raw-output '.ssl_key' /data/options.json)"
LOG_LEVEL="$(jq --raw-output '.
