#!/bin/bash
# Q1: locate the handover directory and copy the robot id and welcome text.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

location=$(cd "$input/handover" && pwd) 
printf '%s\n' "$location" > "$output/location.txt"
cat "$input/handover/.robot-id" > "$output/robot-id.txt"
cat "$input/notes/welcome.txt" > "$output/welcome.txt"
