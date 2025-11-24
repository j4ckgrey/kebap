#!/usr/bin/env bash
# Helper script: prepares Apple signing files for upload to GitHub Secrets
# Usage:
# 1) Export P12 from Keychain Access (GUI) and place it next to this script as cert.p12
# 2) Place AuthKey_XXXXXX.p8 (App Store Connect API key) next to this script
# 3) Optionally place your provisioning profile as profile.mobileprovision
# 4) Run this script to produce base64 files ready to copy/paste or upload with `gh secret set`

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
cd "$HERE" || exit 1

encode() {
  local infile=$1
  local outfile=${infile}.base64
  if [ ! -f "$infile" ]; then
    echo "File $infile not found, skipping"
    return 0
  fi
  # base64 without line wraps
  base64 -w 0 "$infile" > "$outfile"
  echo "Wrote $outfile"
}

echo "Preparing base64 encodings (will produce .base64 files in $HERE)"
encode cert.p12
encode AuthKey_*.p8 || true
encode profile.mobileprovision

echo "Done. Use the resulting .base64 files to set GitHub Secrets or view contents (cat <file>.base64)" 
echo "Example: gh secret set APPLE_SIGN_CERT_P12_BASE64 --body \"$(cat cert.p12.base64 2>/dev/null || echo '')\""
