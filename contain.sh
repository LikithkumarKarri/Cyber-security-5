#!/bin/bash
# contain.sh - simple containment helper
# Usage: sudo ./contain.sh <attacker-ip>
ATTACKER="$1"
if [ -z "$ATTACKER" ]; then
  echo "Usage: sudo ./contain.sh <attacker-ip>"
  exit 1
fi

echo "[*] Preserving evidence (run evidence_collect.sh first)"
# Stop web service to isolate (optional, ensure evidence saved)
echo "[*] Stopping Apache..."
sudo systemctl stop apache2 2>/dev/null || true
sleep 1
echo "[*] Blocking attacker IP: $ATTACKER"
sudo iptables -A INPUT -s "$ATTACKER" -j DROP || true

echo "[*] Containment applied. To remove block:"
echo "sudo iptables -D INPUT -s $ATTACKER -j DROP"
echo "[*] To restart Apache: sudo systemctl start apache2"
