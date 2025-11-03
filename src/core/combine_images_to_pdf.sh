#!/usr/bin/env bash
# GhostPdfShield - Combine PNG back to PDF
# Usage: ./combine_images_to_pdf.sh <temp_dir> <output_pdf>

set -euo pipefail

TEMP_DIR="$1"
OUTPUT_PDF="$2"
COMBINED_PDF="$TEMP_DIR/combined.pdf"

echo "[4/6] Recombining images to PDF..."

convert "$TEMP_DIR"/page-*.png "$COMBINED_PDF"

if [ ! -f "$COMBINED_PDF" ]; then
    echo "[ERROR] Failed to create combined PDF." >&2
    exit 1
fi

mv "$COMBINED_PDF" "$OUTPUT_PDF"
echo "[4/6] Done → $OUTPUT_PDF"