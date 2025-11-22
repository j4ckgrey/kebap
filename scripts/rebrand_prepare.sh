#!/usr/bin/env bash
set -euo pipefail

# Rebrand preparation helper (dry-run first)
# Usage:
#   ./scripts/rebrand_prepare.sh --dry-run    # produce rebrand-dryrun.txt
#   ./scripts/rebrand_prepare.sh --help

OUTFILE="rebrand-dryrun.txt"

if [[ ${1:-} == "--help" ]]; then
  sed -n '1,200p' "$0"
  exit 0
fi

echo "Rebrand dry-run report" > "$OUTFILE"
echo "Generated: $(date --iso-8601=seconds)" >> "$OUTFILE"
echo >> "$OUTFILE"

echo "1) Files containing the token 'Fladder' or 'fladder' (case-sensitive)" >> "$OUTFILE"
echo "-----------------------------------------------------------------" >> "$OUTFILE"
git grep -n "Fladder\|fladder" -- \* 2>/dev/null || true >> "$OUTFILE"
echo >> "$OUTFILE"

echo "2) Icon files that include 'fladder' in the filename" >> "$OUTFILE"
echo "--------------------------------------------------" >> "$OUTFILE"
find icons -type f -iname '*fladder*' -print 2>/dev/null || true >> "$OUTFILE"
echo >> "$OUTFILE"

echo "3) Packaging and metadata files referencing Fladder" >> "$OUTFILE"
echo "------------------------------------------------" >> "$OUTFILE"
grep -R --line-number "DonutWare/Fladder\|nl.jknaapen.fladder\|kebap_icon\|fladder" -I --exclude-dir=.git . 2>/dev/null || true >> "$OUTFILE"
echo >> "$OUTFILE"

echo "4) Suggested next steps" >> "$OUTFILE"
echo "--------------------------" >> "$OUTFILE"
cat <<'EOF' >> "$OUTFILE"
- Review this file and confirm the exact new app name and logo files to apply.
- Decide whether to keep git history. If you want a clean history, remove .git and re-init after applying rebrand.
- Prepare new icons in `icons/production` and `icons/development` and provide them to the repo before applying.
- When ready to apply replacements, run the script with `--apply "NewName"` (not implemented by default in dry-run mode).
EOF

echo "Dry-run saved to: $OUTFILE"
echo "To apply changes automatically you can edit this script to replace tokens and perform backups."

exit 0
