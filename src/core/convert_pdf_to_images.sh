#!/usr/bin/env bash
# GhostPdfShield - Convert PDF to PNG images
# Usage: source this | ./convert_pdf_to_images.sh <input_pdf> <temp_dir>

set -euo pipefail

INPUT_PDF="$1"
TEMP_DIR="$2"
PAGE_PREFIX="$TEMP_DIR/page"

echo "[1/6] Converting PDF to images..."

mkdir -p "$TEMP_DIR"

pdftoppm "$INPUT_PDF" "$PAGE_PREFIX" -png > /dev/null 2>&1

PAGE_COUNT=$(ls -1 "$TEMP_DIR"/page-*.png 2>/dev/null | wc -l || echo 0)
if [ "$PAGE_COUNT" -eq 0 ]; then
    echo "[ERROR] Failed to convert PDF or no pages found." >&2
    exit 1
fi

echo "[1/6] Done ($PAGE_COUNT pages)"