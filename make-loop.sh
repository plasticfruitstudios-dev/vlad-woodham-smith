#!/bin/bash
# Cut a web cover-loop from a master file, matching the specs of the existing
# loops in videos/ (1280x960, 25fps, H.264, silent, yuv420p).
#
# Usage:
#   bash make-loop.sh <source-file> <start> <duration> <output-name>
#
# Example — the Barry Can't Swim cut (3:58, 15 seconds):
#   bash make-loop.sh ~/Desktop/barry-master.mov 00:03:58 15 barry-cant-swim
#
# Output lands in videos/<output-name>.mp4

set -e

SRC="$1"
START="$2"
DUR="$3"
NAME="$4"

if [ -z "$SRC" ] || [ -z "$START" ] || [ -z "$DUR" ] || [ -z "$NAME" ]; then
  echo "Usage: bash make-loop.sh <source-file> <start> <duration> <output-name>"
  echo "   eg: bash make-loop.sh ~/Desktop/barry-master.mov 00:03:58 15 barry-cant-swim"
  exit 1
fi

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC"
  exit 1
fi

cd "$(dirname "$0")"
mkdir -p videos
OUT="videos/${NAME}.mp4"

# -ss before -i = fast seek; re-encoded so the cut is frame-accurate anyway.
# scale+crop to 1280x960 (4:3) to match the other loops, centre-cropped.
ffmpeg -y -ss "$START" -i "$SRC" -t "$DUR" \
  -an \
  -vf "scale=1280:960:force_original_aspect_ratio=increase,crop=1280:960,fps=25" \
  -c:v libx264 -profile:v high -pix_fmt yuv420p \
  -crf 23 -preset slow -movflags +faststart \
  "$OUT"

echo ""
echo "Wrote $OUT"
ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height,r_frame_rate,codec_name \
  -show_entries format=duration,size -of default=nw=1 "$OUT"
echo ""
echo "Now point the cover at it, eg in colour.html:"
echo "  <video src=\"videos/${NAME}.mp4\" autoplay muted loop playsinline preload=\"auto\"></video>"
