#!/bin/sh

# Generate service locations for nginx
generate_service_locations() {
  SERVICES_DECODED="$(echo "$SERVICES" | base64 -d)"
  SERVICE_LOCATIONS=""
  for row in $(echo "${SERVICES_DECODED}" | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }

    SERVICE_NAME=$(_jq '.name')
    SERVICE_IP=$(_jq '.ip')
    SERVICE_LOCATION="location /${SERVICE_NAME}/ { proxy_pass http://${SERVICE_IP}/; }"
    SERVICE_LOCATIONS="${SERVICE_LOCATIONS}\n${SERVICE_LOCATION}"
  done
  echo "${SERVICE_LOCATIONS}"
}

generate_service_locations