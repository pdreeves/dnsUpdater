FROM alpine

LABEL maintainer="github.com/pdreeves"
LABEL repo="https://github.com/pdreeves/dnsUpdater"
LABEL version="1.0.0"
LABEL description="Container used for checking and updating AWS Route53 records"

# Update and install required packages
RUN apk update && apk upgrade && apk add curl bind-tools aws-cli && rm -rf /var/cache/apk/*

# Copy and set script
ADD dnsUpdate.sh /sbin/dnsUpdate.sh
RUN chmod +x /sbin/dnsUpdate.sh

CMD ["/sbin/dnsUpdate.sh"]