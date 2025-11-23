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

echo "1) Files containing the token 'Kebap' or 'kebap' (case-sensitive)" >> "$OUTFILE"
echo "-----------------------------------------------------------------" >> "$OUTFILE"
git grep -n "Kebap\|kebap" -- \* 2>/dev/null || true >> "$OUTFILE"
echo >> "$OUTFILE"

echo "2) Icon files that include 'kebap' in the filename" >> "$OUTFILE"
echo "--------------------------------------------------" >> "$OUTFILE"
find icons -type f -iname '*kebap*' -print 2>/dev/null || true >> "$OUTFILE"
echo >> "$OUTFILE"

echo "3) Packaging and metadata files referencing Kebap" >> "$OUTFILE"
echo "------------------------------------------------" >> "$OUTFILE"
grep -R --line-number "j4ckgrey/Kebap\|nl.jknaapen.kebap\|kebap_icon\|kebap" -I --exclude-dir=.git . 2>/dev/null || true >> "$OUTFILE"
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
