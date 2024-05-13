#!/bin/bash

while true; do
  delay="$[`od -An -N2 -i /dev/urandom` % 5 + 5]";
  [ -n "$delay" ] && echo "delay: $delay" || break;
  sleep "$delay";
  [ -f "/tmp/.config/appsettings.json" ] || continue;
  pName=`grep "trainerBinary" "/tmp/.config/appsettings.json" |cut -d'"' -f4`;
  [ -n "$pName" ] || pName="qli-runner";
  for pid in `ps -ef |grep "${pName}"  |grep -v 'grep' |head -n1 |awk '{print $3 " " $2}'`; do
    pid=`echo "$pid" |grep -o '[0-9]\+'`
    [ -n "$pid" ] && [ "$pid" != "1" ] && echo "kill: $pid" && code=0 || continue
    kill -9 "$pid" >/dev/null 2>&1
  done
done
