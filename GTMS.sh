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

check() {
  for DNS_PAIR in "${DNSTT_SERVERS[@]}"; do
    IFS=':' read -ra DNS <<< "${DNS_PAIR}"
    NS="${DNS[0]}"
    A="${DNS[1]}"

    for TARGET in "${TARGET_DNS[@]}"; do
      if nc -z -w 3 "${TARGET}" 53; then
        echo "Success: DNS Server ${NS} is reachable from ${TARGET} for domain ${A}"
      else
        echo "Error: DNS Server ${NS} is not reachable from ${TARGET} for domain ${A}"
      fi
    done
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo "DNS List: [${TARGET_DNS[*]}]"
echo "CTRL + C to close script"

case "${1:-}" in
  loop|l)
    echo "Script loop: 1 second interval"
    while true; do
      check
      echo '.--. .-.. . .- ... .     .-- .- .. -'
      sleep 1
    done
    ;;
  *)
    check
    ;;
esac

exit 0
