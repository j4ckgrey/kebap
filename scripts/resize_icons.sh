#!/usr/bin/env bash
set -euo pipefail
# Resize and compress Android launcher images to proper mipmap sizes.
# Usage: run from repo root. It will process files under kebap/android/app/src/production/res

ROOT="$(dirname "$0")/.."
RES_DIR="$ROOT/android/app/src/production/res"
if [ ! -d "$RES_DIR" ]; then
  echo "Production res dir not found: $RES_DIR" >&2
  exit 1
fi

declare -A SIZES=( [mipmap-mdpi]=48 [mipmap-hdpi]=72 [mipmap-xhdpi]=96 [mipmap-xxhdpi]=144 [mipmap-xxxhdpi]=192 )

# files to process for launcher mipmap folders
FILES=(ic_launcher.png ic_launcher_foreground.png ic_launcher_monochrome.png launcher_icon.png)

# Notification icon sizes (dp -> px per density)
declare -A NOTIF_SIZES=( [drawable-mdpi]=24 [drawable-hdpi]=36 [drawable-xhdpi]=48 [drawable-xxhdpi]=72 [drawable-xxxhdpi]=96 )
# notification filenames to look for
NOTIF_FILES=(ic_notification_icon.png kebap_notification_icon.png)

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

for D in "${!SIZES[@]}"; do
  SIZE=${SIZES[$D]}
  DIR="$RES_DIR/$D"
  if [ ! -d "$DIR" ]; then
    echo "Skipping missing dir: $DIR"
    continue
  fi
  for F in "${FILES[@]}"; do
    SRC="$DIR/$F"
    if [ ! -f "$SRC" ]; then
      # try with lowercase names
      SRC_ALT="$DIR/$(echo $F | tr '[:upper:]' '[:lower:]')"
      if [ -f "$SRC_ALT" ]; then
        SRC="$SRC_ALT"
      else
        continue
      fi
    fi
    BASENAME=$(basename "$SRC")
    OUT="$DIR/$BASENAME"
    TMP="$TMPDIR/$BASENAME.tmp.png"
    echo "Processing $SRC -> ${SIZE}x${SIZE}"
    # resize while preserving aspect ratio and pad/crop to square
    # Use transparent background so alpha is preserved (do not add white background)
    convert "$SRC" -resize ${SIZE}x${SIZE}^ -background none -gravity center -extent ${SIZE}x${SIZE} -strip "$TMP"
    # compress with pngquant if available, else optipng
    if command -v pngquant >/dev/null 2>&1; then
      pngquant --quality=65-90 --speed=1 --force --output "$OUT" -- "$TMP" || cp "$TMP" "$OUT"
    else
      cp "$TMP" "$OUT"
      if command -v optipng >/dev/null 2>&1; then
        optipng -o7 "$OUT" >/dev/null || true
      fi
    fi
    # ensure file permissions
    chmod 644 "$OUT"
  done
done

# --- Notification icons (drawable-*) ---
declare -A NOTIFY_SIZES=( [drawable-mdpi]=24 [drawable-hdpi]=36 [drawable-xhdpi]=48 [drawable-xxhdpi]=72 [drawable-xxxhdpi]=96 )
NOTIFY_FILES=(ic_notification_icon.png)

for D in "${!NOTIFY_SIZES[@]}"; do
  SIZE=${NOTIFY_SIZES[$D]}
  DIR="$RES_DIR/$D"
  if [ ! -d "$DIR" ]; then
    echo "Skipping missing dir: $DIR"
    continue
  fi
  for F in "${NOTIFY_FILES[@]}"; do
    SRC="$DIR/$F"
    if [ ! -f "$SRC" ]; then
      SRC_ALT="$DIR/$(echo $F | tr '[:upper:]' '[:lower:]')"
      if [ -f "$SRC_ALT" ]; then
        SRC="$SRC_ALT"
      else
        continue
      fi
    fi
    BASENAME=$(basename "$SRC")
    OUT="$DIR/$BASENAME"
    TMP="$TMPDIR/$BASENAME.notify.tmp.png"
    echo "Processing notification $SRC -> ${SIZE}x${SIZE}"
    convert "$SRC" -resize ${SIZE}x${SIZE}^ -background none -gravity center -extent ${SIZE}x${SIZE} -strip "$TMP"
    if command -v pngquant >/dev/null 2>&1; then
      pngquant --quality=65-90 --speed=1 --force --output "$OUT" -- "$TMP" || cp "$TMP" "$OUT"
    else
      cp "$TMP" "$OUT"
      if command -v optipng >/dev/null 2>&1; then
        optipng -o7 "$OUT" >/dev/null || true
      fi
    fi
    chmod 644 "$OUT"
  done
done

echo "\nResulting drawable notification sizes:"
for D in "${!NOTIFY_SIZES[@]}"; do
  DIR="$RES_DIR/$D"
  if [ -d "$DIR" ]; then
    echo "--- $D ---"
    ls -lh "$DIR" | grep ic_notification_icon || true
  fi
done

# Process notification icons in drawable-* folders
for D in "${!NOTIF_SIZES[@]}"; do
  SIZE=${NOTIF_SIZES[$D]}
  DIR="$RES_DIR/$D"
  if [ ! -d "$DIR" ]; then
    echo "Skipping missing drawable dir: $DIR"
    continue
  fi
  for F in "${NOTIF_FILES[@]}"; do
    SRC="$DIR/$F"
    if [ ! -f "$SRC" ]; then
      SRC_ALT="$DIR/$(echo $F | tr '[:upper:]' '[:lower:]')"
      if [ -f "$SRC_ALT" ]; then
        SRC="$SRC_ALT"
      else
        continue
      fi
    fi
    BASENAME=$(basename "$SRC")
    OUT="$DIR/$BASENAME"
    TMP="$TMPDIR/$BASENAME.tmp.png"
    echo "Processing notification $SRC -> ${SIZE}x${SIZE}"
    convert "$SRC" -resize ${SIZE}x${SIZE}^ -background none -gravity center -extent ${SIZE}x${SIZE} -strip "$TMP"
    if command -v pngquant >/dev/null 2>&1; then
      pngquant --quality=65-90 --speed=1 --force --output "$OUT" -- "$TMP" || cp "$TMP" "$OUT"
    else
      cp "$TMP" "$OUT"
      if command -v optipng >/dev/null 2>&1; then
        optipng -o7 "$OUT" >/dev/null || true
      fi
    fi
    chmod 644 "$OUT"
  done
done
# report resulting sizes
echo "\nResulting mipmap sizes:"
for D in "${!SIZES[@]}"; do
  DIR="$RES_DIR/$D"
  if [ -d "$DIR" ]; then
    echo "--- $D ---"
    ls -lh "$DIR" | sed -n '1,200p'
  fi
done
