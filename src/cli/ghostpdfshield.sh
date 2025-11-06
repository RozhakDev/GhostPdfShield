#!/usr/bin/env bash
# GhostPdfShield CLI - Secure PDF Protector
# Usage: ./ghostpdfshield.sh input.pdf [options]
# Options:
#   --output <file>          Output filename (default: input_secure.pdf)
#   --blur <level>           Blur level (0-9, default: 0)
#   --noise <level>          Noise level (0-9, default: 0)
#   --watermark-count <num>  Watermarks per page (default: 5)
#   --no-watermark           Skip watermarking
#   --watermark-list <file>  Custom watermark list (default: config/watermark_list.txt)
#   --owner-pass <pass>      Owner password (default: random 16-char)
#   --verbose                Show detailed output
#   --help                   Show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$SCRIPT_DIR/src/core"
CONFIG_DIR="$SCRIPT_DIR/src/config"
TEMP_DIR="$(pwd)/temp"
WATERMARK_FILE="$CONFIG_DIR/watermark_list.txt"

WATERMARK_COUNT=5
USE_WATERMARK=true
VERBOSE=false
BLUR_LEVEL=0
INPUT_PDF=""
OUTPUT_PDF=""
NOISE_LEVEL=0
OWNER_PASS=$(openssl rand -base64 12)

while [[ $# -gt 0 ]]; do
    case $1 in
        --output) OUTPUT_PDF="$2"; shift 2 ;;
        --blur) BLUR_LEVEL="$2"; shift 2 ;;
        --noise) NOISE_LEVEL="$2"; shift 2 ;;
        --watermark-count) WATERMARK_COUNT="$2"; shift 2 ;;
        --no-watermark) USE_WATERMARK=false; shift ;;
        --watermark-list) WATERMARK_FILE="$2"; shift 2 ;;
        --owner-pass) OWNER_PASS="$2"; shift 2 ;;
        --verbose) VERBOSE=true; shift ;;
        --help)
            echo "Usage: ./ghostpdfshield.sh input.pdf [options]"
            grep '^# Options:' "$0" -A 10 | sed 's/^# //'
            exit 0
            ;;
        -*|--*) echo "[ERROR] Unknown option: $1" >&2; exit 1 ;;
        *) INPUT_PDF="$1"; shift ;;
    esac
done

if [ -z "$INPUT_PDF" ] || [ ! -f "$INPUT_PDF" ]; then
    echo "[ERROR] Input PDF required and must exist." >&2
    exit 1
fi

OUTPUT_PDF="${OUTPUT_PDF:-${INPUT_PDF%.*}_secure.pdf}"

# Check dependecies
for cmd in pdftoppm convert identify qpdf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "[ERROR] Missing dependency: $cmd" >&2
        exit 1
    fi
done

echo "[INIT] GhostPdfShield v1.0 —— Secure Mode Activated"

# Step 1: Convert
bash "$CORE_DIR/convert_pdf_to_images.sh" "$INPUT_PDF" "$TEMP_DIR"

# Step 2: Effects (if levels >0)
if [ "$BLUR_LEVEL" -gt 0 ] || [ "$NOISE_LEVEL" -gt 0 ]; then
    bash "$CORE_DIR/apply_effects.sh" "$TEMP_DIR" --blur "$BLUR_LEVEL" --noise "$NOISE_LEVEL"
else
    echo "[2/6] Applying effects... Skipped"
fi

# Step 3: Watermark (if enabled)
if [ "$USE_WATERMARK" = true ]; then
    bash "$CORE_DIR/apply_watermark.sh" "$TEMP_DIR" "$WATERMARK_FILE" "$WATERMARK_COUNT"
else
    echo "[3/6] Embedding watermarks... Skipped"
fi

# Step 4: Combine
COMBINED_PDF="$TEMP_DIR/combined.pdf"
bash "$CORE_DIR/combine_images_to_pdf.sh" "$TEMP_DIR" "$COMBINED_PDF"

# Step 5: Secure
bash "$CORE_DIR/secure_pdf.sh" "$COMBINED_PDF" "$OWNER_PASS" "$OUTPUT_PDF"

# Step 6: Cleanup
echo "[6/6] Cleaning up temp files..."
find "$TEMP_DIR" -mindepth 1 -not -name '.gitkeep' -delete
echo "[6/6] Done"

echo "[OUTPUT] Secure PDF ready: $OUTPUT_PDF (Password: $OWNER_PASS if needed)"
if [ "$VERBOSE" = true ]; then
    echo "[DETAILS] Blur: $BLUR_LEVEL | Noise: $NOISE_LEVEL | Watermarks: ${USE_WATERMARK:+Yes ($WATERMARK_COUNT/page)}"
fi