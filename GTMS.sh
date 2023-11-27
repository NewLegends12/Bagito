#!/bin/bash

# Your DNSTT Nameserver & your Domain `A` Record
declare -a NS=('sdns.myudp.elcavlaw.com' 'sdns.myudp1.elcavlaw.com' 'sdns.myudph.elcavlaw.com' 'ns-sgfree.elcavlaw.com')
declare -a A=('myudp.elcavlaw.com' 'myudp1.elcavlaw.com' 'myudph.elcavlaw.com' 'sgfree.elcavlaw.com')

# Repeat dig cmd loop time (seconds) (positive integer only)
LOOP_DELAY=5

# Add your DNS IP addresses here
declare -a HOSTS=('124.6.181.12' '124.6.181.36')

# Linux' dig command executable filepath
# Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
# If set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG="/data/data/com.termux/files/usr/bin/dig"

# Log file path
LOG_FILE="dns_hunter_log.txt"

# Verify dig command availability
if [ "$DIG_EXEC" == "DEFAULT" ]; then
  _DIG="$(command -v dig)"
else
  _DIG="$CUSTOM_DIG"
fi

# Check if dig is installed
if [ -z "$_DIG" ]; then
  echo "Error: 'dig' command not found. Install dnsutils or set a valid custom dig executable path."
  exit 1
fi

dns_hunter() {
  echo "DNS Hunter: Searching for leaked IPs..."
  
  # Iterate through each DNS and IP combination
  for ((i=0; i<"${#HOSTS[*]}"; i++)); do
    for R in "${NS}" "${A}" "${NS1}" "${A1}" "${NS2}" "${A2}" "${NS3}" "${A3}" "${NS4}" "${A4}" "${NS5}" "${A5}" "${NS6}" "${A6}"; do
      T="${HOSTS[$i]}"
      
      # Run a command to check if the DNS resolution matches an expected result
      result=$(${_DIG} "@${T}" "${R}" +short 2>/dev/null)
      
      # Define your logic here to identify potential issues
      if [ "${result}" == "Unexpected IP" ]; then
        echo "Potential issue detected: DNS ${T} resolved to unexpected IP ${result}, NameServer: ${R}"
        
        # Log the event with timestamp and details
        log_result "${T}" "${R}" "Unexpected IP" "Potential issue detected"
        
        # Add further actions or logging as needed
        # For example, send an alert, block the IP, etc.
      fi
    done
  done
  
  echo "DNS Hunter: Finished"
}

log_result() {
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${timestamp} - DNS IP: $1, NameServer: $2, Result: $3, Status: $4" >> "$LOG_FILE"
}

countdown() {
  for i in {4..1}; do
    echo "Checking started in $i seconds..."
    sleep 1
  done
}

echo ""
echo "Begin...."
echo ""
countdown
clear

# Main loop
while true; do
  dns_hunter
  sleep $LOOP_DELAY
done
