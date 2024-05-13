#!/bin/bash

while true; do
  #delay="$[`od -An -N2 -i /dev/urandom` % 21600 + 21600]"
  #[ -n "$delay" ] || break
  #sleep "$delay"
  [ -f "/tmp/.config/appsettings.json" ] || continue
  pName=`grep "trainerBinary" "/tmp/.config/appsettings.json" |cut -d'"' -f4`
  [ -n "$pName" ] || pName="qli-runner"
  for pid in `ps -ef |grep "${pName}"  |grep -v 'grep' |awk '{print $2 " " $3}'`; do
    pid=`echo "$pid" |grep -o '[0-9]\+'`
    [ -n "$pid" ] || continue
    kill -9 "$pid" >/dev/null 2>&1
  done
  sleep 60
done



