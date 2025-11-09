#!/bin/bash
# recon.sh - minimal reconnaissance script
# Usage: ./recon.sh <target-ip>
TARGET="${1:-<target-ip>}"
OUTDIR="recon_output"
mkdir -p "$OUTDIR"

echo "[*] Running quick nmap (HTTP ports) against $TARGET"
nmap -sV -p80,443 -T4 "$TARGET" -oN "$OUTDIR/quick_nmap.txt"

echo "[*] Fetching HTTP headers"
curl -I "http://$TARGET/DVWA/" 2>/dev/null | sed -n '1,12p' > "$OUTDIR/headers.txt" || true

echo "[*] Running directory busting (may take time)"
gobuster dir -u "http://$TARGET/DVWA/" -w /usr/share/wordlists/dirb/common.txt -o "$OUTDIR/gobuster.txt" || true

echo "[*] Recon complete. Outputs in $OUTDIR"
