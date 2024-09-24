#!/bin/bash

token="${1:-}"
version="${2:-}"
hugepage="1024"

[ -n "$token" ] || exit 1
[ -n "$version" ] || version=`wget -qO- https://api.github.com/repos/apool-io/apoolminer/releases/latest |grep '"tag_name":' |cut -d'"' -f4`
[ -n "$version" ] || exit 1

sudo apt -qqy update >/dev/null 2>&1 || apt -qqy update >/dev/null 2>&1
sudo apt -qqy install wget procps lsof icu-devtools netcat-traditional >/dev/null 2>&1 || apt -qqy install wget procps lsof icu-devtools netcat-traditional >/dev/null 2>&1
sudo sysctl -w vm.nr_hugepages=$hugepage >/dev/null 2>&1 || sysctl -w vm.nr_hugepages=$hugepage >/dev/null 2>&1

tmp=`mktemp -d`;
wget -qO- "https://github.com/apool-io/apoolminer/releases/download/${version}/apoolminer_linux_${version}.tar" |tar -zx -C "$tmp"

cd "${tmp}"
if [ -f "./run_qubic_cpu.sh" ]; then
  sed -i "s/--account [0-9a-zA-Z_]*/--account ${token}/g" ./run_qubic_cpu.sh
  ./run_qubic_cpu.sh
fi

