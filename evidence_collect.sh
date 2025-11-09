#!/bin/bash
# evidence_collect.sh - collect Apache logs and pcap (if present) and create tar+sha256
EVIDDIR=~/evidence
mkdir -p "$EVIDDIR"
echo "[*] Copying Apache logs (if present)"
sudo cp /var/log/apache2/access.log /var/log/apache2/error.log "$EVIDDIR/" 2>/dev/null || true

# Move pcap if created in /tmp
if [ -f /tmp/attack_capture.pcap ]; then
  echo "[*] Moving /tmp/attack_capture.pcap to $EVIDDIR/"
  mv /tmp/attack_capture.pcap "$EVIDDIR/" 2>/dev/null || true
fi

cd "$EVIDDIR" || exit 1
TS=$(date +%F_%T)
TARFILE="evidence_${TS}.tar.gz"
echo "[*] Creating tar: $TARFILE"
tar czvf "$TARFILE" . || true

echo "[*] Generating SHA256 checksums"
sha256sum "$TARFILE" > "${TARFILE}.sha256" || true
echo "[*] Evidence saved in $EVIDDIR"
ls -lh "$EVIDDIR"
