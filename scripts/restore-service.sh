#!/usr/bin/env bash
# Restore wx-bot systemd unit after a VM replacement. Performs root actions.
set -euo pipefail
if [ "$(id -u)" -ne 0 ]; then echo "must run as root" >&2; exit 1; fi
SCRIPT_PATH="$(readlink -f -- "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
TARGET_HOME="$(dirname "$(dirname "$SCRIPT_DIR")")"
UNIT_BACKUP="$TARGET_HOME/.config/wx-bot/wx-bot.service"
check_trusted_file() {
  local file="$1" owner mode
  if [ ! -f "$file" ] || [ -L "$file" ]; then echo "unsafe or missing file: $file" >&2; return 1; fi
  owner="$(stat -c '%u' -- "$file")"
  mode="$(stat -c '%a' -- "$file")"
  if [ "$owner" != "0" ] || (( (8#$mode & 022) != 0 )); then echo "unsafe owner/permissions: $file" >&2; return 1; fi
}
check_trusted_file "$SCRIPT_PATH"
check_trusted_file "$UNIT_BACKUP"
install -m 0644 -- "$UNIT_BACKUP" /etc/systemd/system/wx-bot.service
systemctl daemon-reload
systemctl enable --now wx-bot
systemctl is-active wx-bot
