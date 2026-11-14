#!/bin/bash
# Install sleepless to /usr/local/bin and add a sudoers rule scoped to the two pmset commands it needs.
set -euo pipefail
[ "$EUID" -eq 0 ] && { echo "Run without sudo: ./install.sh"; exit 1; }
cd "$(dirname "$0")"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$(whoami) ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1" > "$tmp"

sudo visudo -cf "$tmp" >/dev/null
sudo mkdir -p /usr/local/bin
sudo install -m 755 sleepless /usr/local/bin/sleepless
sudo install -m 440 -o root -g wheel "$tmp" /etc/sudoers.d/sleepless
echo "Installed. Run: sleepless"
