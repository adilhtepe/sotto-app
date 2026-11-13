#!/bin/sh
# Smoke test on any OS (also Git Bash on Windows): sotto play on the paced null device receives a
# tone from sotto send (null capture: silence, but real packets) and from vban_send.
# Usage: smoke.sh <build dir with sotto and vban_send>
B=${1:-build}
EXE=; [ -f "$B/sotto.exe" ] && EXE=.exe
[ -f "$B/sotto$EXE" ] || B=$B/Release
"$B/sotto$EXE" play --null -p 17305 -n Smoke --seconds 6 2> play.log &
P=$!
sleep 1
"$B/sotto$EXE" send --null -i 127.0.0.1 -p 17305 -n Smoke --seconds 3 2> send.log
wait $P
cat send.log | tr '\r' '\n' | grep summary
cat play.log | tr '\r' '\n' | grep -E "playing|summary"
pk=$(tr '\r' '\n' < play.log | sed -n 's/^summary: packets \([0-9]*\).*/\1/p')
[ -n "$pk" ] && [ "$pk" -gt 1500 ] && echo "PASS smoke ($pk packets)" || { echo "FAIL smoke"; exit 1; }
