#!/bin/bash

DNSTT_SERVERS=(
  'sdns.myudp.elcavlaw.com:myudp.elcavlaw.com'
  'sdns.myudph.elcavlaw.com:myudph.elcavlaw.com'
  'sdns.myudp1.elcavlaw.com:myudp1.elcavlaw.com'
  'ns-sgfree.elcavlaw.com:sgfree.elcavlaw.com'
)

TARGET_DNS=('124.6.181.12' '124.6.181.36')

_DIG="$(command -v dig)"

if [ -z "${_DIG}" ]; then
  echo "Error: Dig command not found. Please install dnsutils."
  exit 1
fi

endscript() {
  unset DNSTT_SERVERS TARGET_DNS _DIG
  exit 1
}

trap endscript 2 15

check() {
  for DNS_PAIR in "${DNSTT_SERVERS[@]}"; do
    IFS=':' read -ra DNS <<< "${DNS_PAIR}"
    NS="${DNS[0]}"
    A="${DNS[1]}"

    for TARGET in "${TARGET_DNS[@]}"; do
      IP="$(${_DIG} +short "@${TARGET}" "${A}" | tail -n 1)"
      if [ -n "${IP}" ]; then
        echo "Success: NS:${NS} A:${A} TARGET:${TARGET} IP:${IP}"
      else
        echo "Error: Failed to get IP for NS:${NS} A:${A} TARGET:${TARGET}"
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
