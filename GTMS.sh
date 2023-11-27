#!/bin/bash

DNSTT_SERVERS=(
  'sdns.myudp.elcavlaw.com:myudp.elcavlaw.com'
  'sdns.myudph.elcavlaw.com:myudph.elcavlaw.com'
  'sdns.myudp1.elcavlaw.com:myudp1.elcavlaw.com'
  'ns-sgfree.elcavlaw.com:sgfree.elcavlaw.com'
)

TARGET_DNS=('124.6.181.12' '124.6.181.36')

endscript() {
  unset DNSTT_SERVERS TARGET_DNS
  exit 1
}

trap endscript 2 15

heartbeat_animation() {
  while true; do
    echo -ne "\e[1m❤ \e[0m"
    sleep 0.5
  done
}

check_dns() {
  local NS="$1"
  local A="$2"
  local TARGET="$3"

  if nc -z -w 1 "${TARGET}" 53 >/dev/null 2>&1; then
    echo -e "\e[32mSuccess\e[0m: DNS Server ${NS} is reachable from ${TARGET} for domain ${A}"
    heartbeat_animation &  # Start heartbeat animation in the background
    local HEARTBEAT_PID=$!

    # Actual work when connection is successful
    # You can add more tasks here if needed
    sleep 5  # Simulating some work, you can replace this with actual tasks

    # Stop heartbeat animation
    kill -9 "${HEARTBEAT_PID}" >/dev/null 2>&1
    wait "${HEARTBEAT_PID}" 2>/dev/null
    echo -e "\nConnection tasks completed for DNS Server ${NS}"
  else
    echo -e "\e[31mError\e[0m: DNS Server ${NS} is not reachable from ${TARGET} for domain ${A}"
  fi
}

check() {
  while true; do
    for DNS_PAIR in "${DNSTT_SERVERS[@]}"; do
      IFS=':' read -ra DNS <<< "${DNS_PAIR}"
      NS="${DNS[0]}"
      A="${DNS[1]}"

      for TARGET in "${TARGET_DNS[@]}"; do
        check_dns "$NS" "$A" "$TARGET" &
      done
    done

    wait  # Wait for background processes to finish
    echo '.--. .-.. . .- ... .     .-- .- .. -'
    sleep 1
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo "DNS List: [${TARGET_DNS[*]}]"
echo "CTRL + C to close script"

check
exit 0
