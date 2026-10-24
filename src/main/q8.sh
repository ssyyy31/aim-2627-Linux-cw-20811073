#!/bin/bash
# Q8: repair the collector and HTTP service, then clean up.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}
action=${3:-repair}

. "$input/process.env"

wait_stopped() {
    pid=$1
    count=0
    while [ "$count" -lt 50 ]; do
        if [ ! -r "/proc/$pid/stat" ]; then
            return 0
        fi
        state=$(sed 's/^.*) //' "/proc/$pid/stat" | cut -d' ' -f1)
        if [ "$state" = "Z" ]; then
            return 0
        fi
        count=$((count + 1))
        sleep 0.05
    done
    return 1
}

if [ "$action" = "repair" ]; then
    {
        printf 'pid=%s\n'     "$(ps -ww -p "$TARGET_PID" -o pid= | tr -d ' ')"
        printf 'user=%s\n'    "$(ps -ww -p "$TARGET_PID" -o user:20= | tr -d ' ')"
        printf 'state=%s\n'   "$(ps -ww -p "$TARGET_PID" -o state= | tr -d ' ')"
        printf 'command=%s\n' "$(ps -ww -p "$TARGET_PID" -o args=)"
    } > "$output/process.txt"

    grep -F "TICK $TARGET_TOKEN " "$WORKER_LOG" | tail -n 5 \
        > "$output/collector-sample.log"

    kill -TERM "$TARGET_PID" 2>/dev/null || true
    wait_stopped "$TARGET_PID" || true

    kill -TERM "$SERVICE_PID" 2>/dev/null || true
    wait_stopped "$SERVICE_PID" || true

    printf 'bind=127.0.0.1\nport=%s\nroute=/status\n' "$TARGET_PORT" \
        > "$output/server.conf"
    bash "$START_TOOL" "$output/server.conf" "$output/service"

    code=""
    count=0
    while [ "$count" -lt 50 ]; do
        code=$(curl -s -o "$output/http-body.txt" -w '%{http_code}' \
            --max-time 1 "http://127.0.0.1:$TARGET_PORT/status" || true)
        if [ "$code" = "200" ]; then
            break
        fi
        count=$((count + 1))
        sleep 0.05
    done
    printf '%s\n' "$code" > "$output/http-status.txt"
else
    if [ -r "$output/service/pid" ]; then
        service_pid=$(tr -d '[:space:]' < "$output/service/pid")
        kill -TERM "$service_pid" 2>/dev/null || true
        wait_stopped "$service_pid" || true
    fi
fi
