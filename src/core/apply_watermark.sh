#!/usr/bin/env bash
# GhostPdfShield - Apply random multi-watermark
# Usage: ./apply_watermark.sh <temp_dir> <watermark_file> <count_per_page>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR="$1"
WATERMARK_FILE="$2"
COUNT_PER_PAGE="${3:-5}"

if [ ! -f "$WATERMARK_FILE" ]; then
    echo "[WARN] Watermark list not found: $WATERMARK_FILE. Skipping watermark."
    exit 0
fi

mapfile -t WATERMARK_LIST < "$WATERMARK_FILE"
if [ ${#WATERMARK_LIST[@]} -eq 0 ]; then
    echo "[WARN] Watermark list empty. Skipping."
    exit 0
fi

echo "[3/6] Embedding watermarks ($COUNT_PER_PAGE per page)..."

FONT_DIR="$SCRIPT_DIR/../../assets/fonts"
AVAILABLE_FONTS=()
if [ -d "$FONT_DIR" ]; then
    mapfile -t AVAILABLE_FONTS < <(find "$FONT_DIR" -name "*.ttf" -o -name "*.otf" | sort)
fi

for img in "$TEMP_DIR"/page-*.png; do
    [ ! -f "$img" ] && continue

    WIDTH=$(identify -format "%w" "$img" | head -n1)
    HEIGHT=$(identify -format "%h" "$img" | head -n1)
    edited_img="$img"

    for ((i=1; i<=COUNT_PER_PAGE; i++)); do
        TEXT="${WATERMARK_LIST[$RANDOM % ${#WATERMARK_LIST[@]}]}"
        X=$((RANDOM % (WIDTH - 200) + 100))
        Y=$((RANDOM % (HEIGHT - 100) + 50))
        ANGLE=$((RANDOM % 360))

        FONT_ARG="DejaVu-Sans"
        if [ ${#AVAILABLE_FONTS[@]} -gt 0 ]; then
            FONT_ARG="${AVAILABLE_FONTS[$RANDOM % ${#AVAILABLE_FONTS[@]}]}"
        fi
        
        convert "$edited_img" \
            -font "$FONT_ARG" \
            -pointsize 48 \
            -fill "rgba(0,0,0,0.13)" \
            -stroke "white" -strokewidth 1 \
            -annotate +"${X}"+"${Y}" "$TEXT" \
            "$edited_img.tmp" && mv "$edited_img.tmp" "$edited_img"
    done
done

echo "[3/6] Done"