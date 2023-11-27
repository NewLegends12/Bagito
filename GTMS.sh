#!/bin/bash

# Initialize the counter
count=1

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
LOG_FILE="dns_checker_log.txt"

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

check() {
  local border_color="\e[95m"
  local success_color="\e[92m"
  local fail_color="\e[91m"
  local header_color="\e[96m"
  local reset_color="\e[0m"
  local padding="  "

  # Header
  echo -e "${border_color}↓✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴↓${reset_color}"
  echo -e "${border_color}│${header_color}${padding}DNS Status Check Results${padding}${reset_color}"
  echo -e "${border_color}↕✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰↕${reset_color}"

  # Results (Run queries in parallel for faster execution)
  for T in "${HOSTS[@]}"; do
    for ((i=0; i<"${#NS[@]}"; i++)); do
      R="${NS[$i]}"
      A_record="${A[$i]}"
      
      if result=$(${_DIG} "@${T}" "${R}" +short 2>/dev/null); then
        if [ -z "${result}" ]; then
          STATUS="${success_color}Success${reset_color}"
        else
          STATUS="${fail_color}Failed${reset_color}"
        fi
      else
        STATUS="${fail_color}Failed${reset_color}"
        result="Error"
      fi

      log_result "${T}" "${R}" "${A_record}" "${STATUS}" "${result}"

      echo -e "${border_color}↕${padding}${reset_color}DNS IP: ${T}${padding}${reset_color}"
      echo -e "${border_color}↕${padding}NameServer: ${R}${padding}${reset_color}"
      echo -e "${border_color}↕${padding}A Record: ${A_record}${padding}${reset_color}"
      echo -e "${border_color}↕${padding}Status: ${STATUS}${padding}${reset_color}"
      echo -e "${border_color}↕${padding}Result: ${result}${padding}${reset_color}"
    done
  done

  # Check count and Loop Delay
  echo -e "${border_color}↕✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰↕${reset_color}"
  echo -e "${border_color}↕${padding}${header_color}Check count: ${count}${padding}${reset_color}"
  echo -e "${border_color}↕${padding}Loop Delay: ${LOOP_DELAY} seconds${padding}${reset_color}"

  # Footer
  echo -e "${border_color}↑✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴✴↑${reset_color}"
}

log_result() {
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "${timestamp} - DNS IP: $1, NameServer: $2, A Record: $3, Status: $4, Result: $5" >> "$LOG_FILE"
}

countdown() {
  for i in {5..1}; do
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
  check
  ((count++))  # Increment the counter
  sleep $LOOP_DELAY
done
