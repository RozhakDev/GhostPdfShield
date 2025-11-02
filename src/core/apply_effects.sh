#!/usr/bin/env bash
# GhostPdfShield - Apply blur & noise (optional)
# Usage: ./apply_effects.sh <temp_dir> [--blur <level>] [--noise <level>]

set -euo pipefail

TEMP_DIR="$1"
shift
BLUR_LEVEL=0
NOISE_LEVEL=0

while [[ $# -gt 0 ]]; do
    case $1 in
        --blur) BLUR_LEVEL="$2"; shift 2 ;;
        --noise) NOISE_LEVEL="$2"; shift 2 ;;
        *) echo "[ERROR] Unknown parameter: $1" >&2; exit 1 ;;
    esac
done

echo "[2/6] Applying effects (blur:$BLUR_LEVEL, noise:$NOISE_LEVEL)..."

for img in "$TEMP_DIR"/page-*.png; do
    [ ! -f "$img" ] && continue

    if [ "$BLUR_LEVEL" -gt 0 ]; then
        convert "$img" -blur "0x$BLUR_LEVEL" "$img.tmp" && mv "$img.tmp" "$img"
    fi

    if [ "$NOISE_LEVEL" -gt 0 ]; then
        convert "$img" -noise "$NOISE_LEVEL" "$img.tmp" && mv "$img.tmp" "$img"
    fi
done

echo "[2/6] Done"