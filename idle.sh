#!/bin/sh

mode="${1:-0}"
execPath="${2:-/root/.cache/test}"

[ -e "$execPath" ] || exit 1
fuser "$execPath" >/dev/null 2>&1
execStatus="$?"


[ "$mode" -eq "0" ] && [ "$execStatus" -eq "0" ] && echo -n "InRunning... "
[ "$mode" -eq "0" ] && [ "$execStatus" -eq "1" ] && echo -n "Starting... " && sh -c "cd ${execPath%/*} && nice -n 19 ./${execPath##*/} >/dev/null 2>&1 &" >/dev/null 2>&1

[ "$mode" -eq "1" ] && [ "$execStatus" -eq "0" ] && echo -n "Stoping... " && fuser -k "$execPath" >/dev/null 2>&1
[ "$mode" -eq "1" ] && [ "$execStatus" -eq "1" ] && echo -n "AlreadyStopped! "

exit 0

