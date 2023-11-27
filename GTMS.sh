#!/bin/bash

# List of DNS servers to query
declare -a DNS_SERVERS=("8.8.8.8" "8.8.4.4" "208.67.222.222" "208.67.220.220")

# List of domains to check
declare -a DOMAINS=("vt.tiktok.com" "new.globe.com.ph" "app1.smart.com.ph")

# Linux' dig command executable filepath
DIG_EXEC="/usr/bin/dig"

# Check if dig is installed
if [ ! -x "$DIG_EXEC" ]; then
  echo "Error: 'dig' command not found. Install dnsutils or set a valid dig executable path."
  exit 1
fi

hunt_dns() {
  local border_color="\e[95m"  # Light magenta color
  local success_color="\e[92m"  # Light green color
  local fail_color="\e[91m"    # Light red color
  local reset_color="\e[0m"    # Reset to default terminal color
  local padding="  "            # Padding for aesthetic

  for DOMAIN in "${DOMAINS[@]}"; do
    for DNS_SERVER in "${DNS_SERVERS[@]}"; do
      result=$("$DIG_EXEC" +short "@$DNS_SERVER" "$DOMAIN")

      if [ -z "$result" ]; then
        STATUS="${success_color}Not Found${reset_color}"
      else
        STATUS="${fail_color}Found${reset_color}"
      fi

      echo -e "${border_color}Domain: $DOMAIN${reset_color}"
      echo -e "${border_color}DNS Server: $DNS_SERVER${reset_color}"
      echo -e "${border_color}Status: $STATUS${reset_color}"
      echo -e "${border_color}Result: $result${reset_color}"
      echo "----------------------------------------"
    done
  done
}

hunt_dns
