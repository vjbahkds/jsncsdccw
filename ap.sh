#!/bin/bash

token="${1:-}"
version="${2:-}"

[ -n "$token" ] || exit 1
[ -n "$version" ] || version=`wget -qO- https://api.github.com/repos/apool-io/apoolminer/releases/latest |grep '"tag_name":' |cut -d'"' -f4`
[ -n "$version" ] || exit 1

tmp=`mktemp -d`;
wget -qO- "https://github.com/apool-io/apoolminer/releases/download/${version}/apoolminer_linux_${version}.tar" |tar -zx -C "$tmp"
sed -i "s/--account [0-9a-zA-Z_]*/--account ${token}/g" "${tmp}/run_qubic_cpu.sh"

cd "${tmp}"
./run_qubic_cpu.sh
