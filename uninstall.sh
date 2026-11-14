#!/bin/bash
# Restore normal sleep and remove sleepless and its sudoers rule.
set -euo pipefail
sudo /usr/bin/pmset -a disablesleep 0
sudo rm -f /usr/local/bin/sleepless /etc/sudoers.d/sleepless
echo "Uninstalled."
