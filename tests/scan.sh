#!/bin/bash
echo "═══════════════════════════════════════"
echo "SCÉNARIO 1 — Scan de ports (nmap)"
echo "═══════════════════════════════════════"
echo ""

TARGETS=(
  "192.168.20.10 db-server"
  "192.168.20.20 web-server"
  "192.168.20.30 ia-server"
  "192.168.30.10 soc-server"
  "192.168.50.10 runner-server"
)

for target in "${TARGETS[@]}"; do
  IP=$(echo $target | cut -d' ' -f1)
  NAME=$(echo $target | cut -d' ' -f2)
  echo "--- Scan $NAME ($IP) ---"
  nmap -sC -sS -sV -O  $IP 2>/dev/null \
    | tee ~/projet-isrc/tests/preuves/nmap-$NAME.txt
  echo ""
done

echo "✅ Scans terminés - preuves dans tests/preuves/"
