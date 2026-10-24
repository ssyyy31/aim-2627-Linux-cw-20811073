#!/bin/bash
# Q5: run the pre-flight check and record its output, status, and diagnosis.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

. "$input/launch.env"

if bash "$LAUNCH_TOOL" "$MODEL_PATH" "$CAMERA_PATH" \
    > "$output/stdout.log" 2> "$output/stderr.log"; then
    status=0
else
    status=$?
fi

printf '%s\n' "$status" > "$output/exit-code.txt"

case "$status" in
    0)  result=SUCCESS; reason=NONE ;;
    10) result=FAILED;  reason=MODEL_MISSING ;;
    20) result=FAILED;  reason=CAMERA_DENIED ;;
    *)  result=FAILED;  reason=UNKNOWN ;;
esac

printf 'result=%s\nexit_code=%s\nreason=%s\n' \
    "$result" "$status" "$reason" > "$output/report.txt"
