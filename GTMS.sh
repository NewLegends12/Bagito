#!/bin/bash

# Your DNSTT Nameserver & your Domain `A` Record
NS='sdns.myudp.elcavlaw.com'
A='myudp.elcavlaw.com'
NS1='sdns.myudph.elcavlaw.com'
A1='myudph.elcavlaw.com'
NS2='sdns.myudp1.elcavlaw.com'
A2='myudp1.elcavlaw.com'
NS3='ns-sgfree.elcavlaw.com'
A3='sgfree.elcavlaw.com'

# Repeat dig cmd loop time (seconds) (positive integer only)
LOOP_DELAY=1

# Add your DNS here
declare -a HOSTS=('124.6.181.12' '124.6.181.36')

# Linux' dig command executable filepath
_DIG="$(command -v dig)"

if [ -z "${_DIG}" ]; then
  echo "Error: Dig command not found. Please install dnsutils."
  exit 1
fi

endscript() {
  unset NS A NS1 A1 NS2 A2 NS3 A3 LOOP_DELAY HOSTS _DIG
  exit 1
}

trap endscript 2 15

check() {
  for T in "${HOSTS[@]}"; do
    for R in "${A}" "${NS}" "${A1}" "${NS1}" "${A2}" "${NS2}" "${A3}" "${NS3}"; do
      IP="$(${_DIG} +short "@${T}" "${R}" | tail -n 1)"
      if [ -n "${IP}" ]; then
        echo "Success: R:${R} D:${T} IP:${IP}"
      else
        echo "Error: Failed to get IP for R:${R} D:${T}"
      fi
    done
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo "DNS List: [${HOSTS[*]}]"
echo "CTRL + C to close script"

[[ "${LOOP_DELAY}" -eq 1 ]] && let "LOOP_DELAY++";

case "${1:-}" in
  loop|l)
    echo "Script loop: ${LOOP_DELAY} seconds"
    while true; do
      check
      echo '.--. .-.. . .- ... .     .-- .- .. -'
      sleep "${LOOP_DELAY}"
    done
    ;;
  *)
    check
    ;;
esac

exit 0
