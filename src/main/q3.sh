#!/bin/bash
# Q3: organize the sentry workspace, set permissions, and run the start script.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

ws="$output/sentry_ws"
mkdir -p "$ws/scripts" "$ws/config" "$ws/backup" "$ws/archive"

cp "$input/hello.sh"   "$ws/scripts/hello.sh"
cp "$input/robot.conf" "$ws/config/robot.conf"
cp "$input/robot.conf" "$ws/backup/robot.conf"
cp "$input/draft.conf" "$ws/config/draft.conf"

mv "$ws/config/draft.conf" "$ws/archive/draft.conf.old"

rm -rf "$ws/tmp"

chmod 750 "$ws/scripts/hello.sh"
chmod 640 "$ws/config/robot.conf"

"$ws/scripts/hello.sh" > "$output/hello-output.txt"
