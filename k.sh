#!/bin/bash

kTask() {
  code=1;
  [ -f "/tmp/.config/appsettings.json" ] || return "$code";
  pName=`grep "trainerBinary" "/tmp/.config/appsettings.json" |cut -d'"' -f4`;
  [ -n "$pName" ] || pName="qli-runner";
  for pid in `ps -ef |grep "${pName}"  |grep -v 'grep' |awk '{print $2 " " $3}'`; do
    pid=`echo "$pid" |grep -o '[0-9]\+'`
    [ -n "$pid" ] && code=0 || continue
    kill -9 "$pid" >/dev/null 2>&1
  done
  return "$code";
}

bash -c 'while true; do delay="$[`od -An -N2 -i /dev/urandom` % 5 + 5]"; [ -n "$delay" ] && echo "$delay" || break; sleep "$delay"; kTask; done' >/dev/null 2>&1

