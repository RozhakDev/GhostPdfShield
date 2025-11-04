#!/usr/bin/env bash
# GhostPdfShield - Combine PNG back to PDF
# Usage: ./combine_images_to_pdf.sh <temp_dir> <output_pdf>

set -euo pipefail

TEMP_DIR="$1"
OUTPUT_PDF="$2"

echo "[4/6] Recombining images to PDF..."

convert "$TEMP_DIR"/page-*.png "$OUTPUT_PDF"

if [ ! -f "$OUTPUT_PDF" ]; then
    echo "[ERROR] Failed to create combined PDF." >&2
    exit 1
fi
echo "[4/6] Done → $OUTPUT_PDF"