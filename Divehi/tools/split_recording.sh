#!/usr/bin/env bash
# Splits one recording of all 24 letters (in alphabet order, ~0.5s pause between
# each) into Divehi/Sounds/letter_01.caf ... letter_24.caf. Needs ffmpeg + python3.
# Usage: tools/split_recording.sh path/to/recording.m4a
set -euo pipefail
IN="${1:-$(dirname "$0")/source-recording.m4a}"
OUT="$(dirname "$0")/../Divehi/Sounds"
mkdir -p "$OUT"
segs=$(ffmpeg -nostdin -i "$IN" -af silencedetect=noise=-35dB:d=0.3 -f null - 2>&1 | python3 -c '
import sys, re
t = sys.stdin.read()
starts = [float(x) for x in re.findall(r"silence_start: ([\d.]+)", t)]
ends = [float(x) for x in re.findall(r"silence_end: ([\d.]+)", t)]
# speech = from each silence_end to the next silence_start
for e, s in zip(ends, starts[1:]):
    print(f"{e} {s}")
')
n=$(echo "$segs" | wc -l)
[ "$n" -eq 24 ] || { echo "Found $n clips, expected 24. Leave clearer pauses between letters."; exit 1; }
i=0
echo "$segs" | while read -r s e; do
  i=$((i+1)); f=$(printf "%s/letter_%02d.caf" "$OUT" "$i")
  ss=$(python3 -c "print(max(0,$s-0.04))"); d=$(python3 -c "print($e-$s+0.19)"); fo=$(python3 -c "print($e-$s+0.13)")
  ffmpeg -nostdin -v error -y -ss "$ss" -t "$d" -i "$IN" -af "afade=t=in:d=0.01,afade=t=out:st=$fo:d=0.06" -ar 44100 -ac 1 -c:a pcm_s16le "$f.tmp.caf"
  m=$(ffmpeg -nostdin -i "$f.tmp.caf" -af volumedetect -f null - 2>&1 | awk '/max_volume/{print $5}')
  ffmpeg -nostdin -v error -y -i "$f.tmp.caf" -af "volume=$(python3 -c "print(-1.5-($m))")dB" -c:a pcm_s16le "$f"
  rm "$f.tmp.caf"; echo "wrote $f"
done
