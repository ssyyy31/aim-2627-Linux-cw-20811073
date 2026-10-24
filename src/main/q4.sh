#!/bin/bash
# Q4: merge logs, extract levels, keep recent lines, and count errors.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

cat "$input/boot.log" "$input/run.log" > "$output/all.log"

grep '^ERROR ' "$output/all.log" > "$output/errors.log" || true
grep -E '^(WARN|ERROR) ' "$output/all.log" > "$output/attention.log" || true

tail -n 5 "$output/all.log" > "$output/recent.log"
head -n 3 "$output/errors.log" > "$output/first-errors.log"

wc -l < "$output/errors.log" > "$output/error-count.txt"

