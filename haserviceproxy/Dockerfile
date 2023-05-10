ARG BUILD_FROM
FROM $BUILD_FROM

# Set the working directory
WORKDIR /usr/src/app

# Update packages and install dependencies
RUN apk update && apk add --no-cache nginx jq

# Copy the configuration template and the run script
COPY nginx.conf.tpl /nginx.conf.tpl
COPY run.sh /run.sh

# Make the run script executable
RUN chmod a+x /run.sh

# Set the entrypoint
ENTRYPOINT ["/run.sh"]
