#!/bin/bash

# List of DNS servers to query
declare -a DNS_SERVERS=("124.6.181.12" "124.6.181.20")

# Domain to check
DOMAIN="ns-sgfree.elcavlaw.com"

# Linux' dig command executable filepath
DIG_EXEC="/usr/bin/dig"

# Check if dig is installed
if [ ! -x "$DIG_EXEC" ]; then
  echo "Error: 'dig' command not found. Install dnsutils or set a valid dig executable path."
  exit 1
fi

# Function to query DNS
query_dns() {
  for DNS_SERVER in "${DNS_SERVERS[@]}"; do
    result=$("$DIG_EXEC" +short "@$DNS_SERVER" "$DOMAIN")

    if [ -z "$result" ]; then
      echo "Domain: $DOMAIN | DNS Server: $DNS_SERVER | Status: Not Found"
    else
      echo "Domain: $DOMAIN | DNS Server: $DNS_SERVER | Status: Found | Result: $result"
    fi
  done
}

# Execute DNS hunting
query_dns
