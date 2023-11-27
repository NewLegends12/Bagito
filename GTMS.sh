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

## Your DNSTT Nameserver & your Domain `A` Record
NS='sdns.myudp.elcavlaw.com'
A='myudp.elcavlaw.com'
NS1='ns-artph.elcavlaw.com'
A1='artph.elcavlaw.com'
NS2='sdns.myudp1.elcavlaw.com'
A2='myudp1.elcavlaw.com'
NS3='sdns.myudph.elcavlaw.com'
A3='myudp1.elcavlaw.com'
NS4='sdns.myuph.elcavlaw.com'
A4='myudph.elcavlaw.com'
NS5='ns-sgfree.elcavlaw.com'
A5='sgfree.elcavlaw.com'
NS6='ns-artsg2.elcavlaw.com'
A6='artsg2.elcavlaw.com'

## Repeat dig cmd loop time (seconds) (positive interger only)
LOOP_DELAY=0

## Add your DNS here
declare -a HOSTS=('124.6.181.20' '124.6.181.25' '112.198.115.44' '112.198.115.36' '124.6.181.12' '124.6.181.36')

## Linux' dig command executable filepath
## Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
## if set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG=/data/data/com.termux/files/home/go/bin/fastdig

######################################
######################################
######################################
######################################
######################################
VER=0.1
case "${DIG_EXEC}" in
 DEFAULT|D)
 _DIG="$(command -v dig)"
 ;;
 CUSTOM|C)
 _DIG="${CUSTOM_DIG}"
 ;;
esac
if [ ! $(command -v ${_DIG}) ]; then
 printf "%b" "Dig command failed to run, " \
 "please install dig(dnsutils) or check " \
 "\$DIG_EXEC & \$CUSTOM_DIG variable inside $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "$0") file.\n" && exit 1
fi
endscript() {
 unset NS A NS1 A1 NS2 A2 NS3 A3 NS4 A4 NS5 A5 NS6 A6 LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M
 exit 1
}
trap endscript 2 15
check(){
 for ((i=0; i<"${#HOSTS[*]}"; i++)); do
  for R in "${NS}" "${A}" "${NS1}" "${A1}" "${NS2}" "${A2}" "${NS3}" "${A3}" "${NS4}" "${A4}" "${NS5}" "${A5}" "${NS6}" "${A6}"; do
   T="${HOSTS[$i]}"
   [[ -z $(timeout -k 3 3 ${_DIG} @${T} ${R}) ]] && M=31 || M=32;
   echo -e "\e[1;${M}m\$ R:${R} D:${T}\e[0m"
   unset T R M
  done
 done
}
echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"
[[ "${LOOP_DELAY}" -eq 1 ]] && let "LOOP_DELAY++";
case "${@}" in
 loop|l)
 echo "Script loop: ${LOOP_DELAY} seconds"
 while true; do
  check
  echo '.--. .-.. . .- ... .     .-- .- .. -'
  sleep ${LOOP_DELAY}
 done
 ;;
 *)
 check
 ;;
esac
exit 0
