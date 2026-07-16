#!/usr/bin/env bash
# Export Raid Map board SVG masters at 300 DPI for factory print.
# Requires Inkscape: brew install inkscape
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${ROOT}/documents/board_print_300dpi"
DPI=300
mkdir -p "$OUT"

if ! command -v inkscape >/dev/null 2>&1; then
  echo "Inkscape not found. Install: brew install inkscape"
  echo "SVG masters are in assets/board/ — open in Illustrator/Figma at 300 DPI."
  exit 1
fi

# Room vignettes: 400×280 SVG → ~4.2×2.9 in at 300 DPI
for f in room_living room_study room_kitchen room_garden vault_emblem; do
  inkscape "${ROOT}/assets/board/${f}.svg" \
    --export-type=png \
    --export-dpi="${DPI}" \
    --export-filename="${OUT}/${f}_${DPI}dpi.png"
  echo "Exported ${f}_${DPI}dpi.png"
done

echo "Print masters → ${OUT}/"
