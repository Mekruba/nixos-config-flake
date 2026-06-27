#!/bin/bash
iface=$(ip link show | awk '/^[0-9]+: enp/{dev=$2} /state UP/{if (dev) print dev}' | tr -d ':' | head -1)
echo "$iface"
