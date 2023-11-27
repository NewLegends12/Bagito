#!/bin/bash

DNSTT_SERVERS=(
  'sdns.myudp.elcavlaw.com:myudp.elcavlaw.com'
  'ns-artph.elcavlaw.com:artph.elcavlaw.com'
  'sdns.myudp1.elcavlaw.com:myudp1.elcavlaw.com'
  'sdns.myudph.elcavlaw.com:myudp1.elcavlaw.com'
  'ns-artph1.elcavlaw.com:artph1.elcavlaw.com'
  'ns-artsg1.elcavlaw.com:artsg1.elcavlaw.com'
  'ns-artsg2.elcavlaw.com:artsg2.elcavlaw.com'
  'sdns.myudp.elcavlaw.com:myudp.elcavlaw.com'
  'sdns.myudph.elcavlaw.com:myudph.elcavlaw.com'
  'sdns.myudp1.elcavlaw.com:myudp1.elcavlaw.com'
  'ns-sgfree.elcavlaw.com:sgfree.elcavlaw.com'
)

TARGET_DNS=('124.6.181.20' '124.6.181.25' '112.198.115.44' '112.198.115.36' '124.6.181.12' '124.6.181.36')

endscript() {
  unset DNSTT_SERVERS TARGET_DNS
  exit 1
}

trap endscript 2 15

heartbeat_animation() {
  local color="$1"
  while true; do
    echo -ne "\e[${color}m❤ \e[0m"
    sleep 0.5
  end

check_dns() {
  local NS="$1"
  local A="$2"
  local TARGET="$3"
  local RETRIES=3
  local TIMEOUT=2

  for ((i = 0; i < RETRIES; i++)); do
    if nc -z -w "${TIMEOUT}" "${TARGET}" 53; then
      echo -e "\e[32mSuccess\e[0m: DNS Server ${NS} is reachable from ${TARGET} for domain ${A}"
      heartbeat_animation "32" &  # Start green heartbeat animation in the background
      local HEARTBEAT_PID=$!

      # Actual work when connection is successful
      # You can add more tasks here if needed
      sleep 5  # Simulating some work, you can replace this with actual tasks

      # Stop heartbeat animation
      kill -9 "${HEARTBEAT_PID}" >/dev/null 2>&1
      wait "${HEARTBEAT_PID}" 2>/dev/null
      echo -e "\nConnection tasks completed for DNS Server ${NS}"
      return 0  # Success
    fi
    sleep 1  # Wait before retrying
  done

  echo -e "\e[31mError\e[0m: DNS Server ${NS} is not reachable from ${TARGET} for domain ${A}"
  heartbeat_animation "31" &  # Start red heartbeat animation in the background
  sleep 5  # Simulating some work, you can replace this with actual tasks
  echo -e "\nError handling completed for DNS Server ${NS}"
  return 1  # Error
}

check() {
  while true; do
    for DNS_PAIR in "${DNSTT_SERVERS[@]}"; do
      IFS=':' read -ra DNS <<< "${DNS_PAIR}"
      NS="${DNS[0]}"
      A="${DNS[1]}"

      for TARGET in "${TARGET_DNS[@]}"; do
        check_dns "$NS" "$A" "$TARGET"
      done
    done

    echo '.--. .-.. . .- ... .     .-- .- .. -'
    sleep 1
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo "DNS List: [${TARGET_DNS[*]}]"
echo "CTRL + C to close script"

check
exit 0