#!/bin/bash
# Q2: create the sentry workspace layout and its initial files.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

ws="$output/sentry_ws"
mkdir -p "$ws/scripts" "$ws/config" "$ws/logs" "$ws/tmp"

: > "$ws/logs/.keep"
: > "$ws/tmp/scratch.txt"

cat > "$ws/scripts/hello.sh" <<'EOF'
#!/bin/bash
echo "Hello, AIM Linux!"
EOF

cat > "$ws/config/robot.conf" <<'EOF'
robot=sentry
mode=training
log_level=INFO
EOF
