#!/usr/bin/env bash
# GhostPdfShield - Apply qpdf protection
# Usage: ./secure_pdf.sh <input_pdf> <owner_password> <final_output>

set -euo pipefail

INPUT_PDF="$1"
OWNER_PASS="$2"
FINAL_OUTPUT="$3"

echo "[5/6] Securing PDF (extract=no, modify=none)..."

qpdf --encrypt "" "$OWNER_PASS" 256 \
    --modify=none --extract=n \
    -- "$INPUT_PDF" "$FINAL_OUTPUT"

echo "[5/6] Done → $FINAL_OUTPUT"