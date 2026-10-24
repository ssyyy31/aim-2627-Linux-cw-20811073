#!/bin/bash
# Q6: install the local Debian package into a private sysroot and run it.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

root="$output/sysroot"
mkdir -p "$root"

dpkg --root="$root" --force-not-root --log=/dev/null \
    -i "$input/aim-sentry-tools.deb"

"$root/usr/bin/aim-sentry-info" > "$output/tool-output.txt"

