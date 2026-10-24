#!/usr/bin/env bash
# Muse hook adapter for wx-bot pull delivery. Not standalone.
# Requires HATCH_HOOK_RUNTIME and platform-provided log/wake/silent helpers.
set -euo pipefail
source "$HATCH_HOOK_RUNTIME"
WXBOT="$HOME/.local/bin/wx-bot"
BINDING="muse"
STATE_DIR="$HOME/hooks/state"
MARK="$STATE_DIR/wechat-hook-alerted"
WAKE_STATE="$STATE_DIR/wechat-hook-last-wake"
RESTORE_STATE="$STATE_DIR/wechat-hook-last-restore"
RESTORE_LOCK="$STATE_DIR/wechat-hook-restore.lock"
UNIT_FILE="/etc/systemd/system/wx-bot.service"
RESTORE_SCRIPT="$HOME/.config/wx-bot/restore-service.sh"
mkdir -p "$STATE_DIR"
now="$(date +%s)"

# Restore only when the unit is missing. The restore script must be root-owned,
# non-symlinked, and not writable by group/other; it performs privileged actions.
if [ ! -e "$UNIT_FILE" ] && [ "${HATCH_HOOK_DRY_RUN:-0}" != "1" ]; then
  last_attempt=0
  if [ -f "$RESTORE_STATE" ]; then read -r last_attempt < "$RESTORE_STATE" || true; last_attempt="${last_attempt:-0}"; fi
  if [ $((now - last_attempt)) -ge 600 ]; then
    printf '%s\n' "$now" > "$RESTORE_STATE"
    safe=0
    if [ -f "$RESTORE_SCRIPT" ] && [ ! -L "$RESTORE_SCRIPT" ]; then
      owner="$(stat -c '%u' -- "$RESTORE_SCRIPT" 2>/dev/null || echo unknown)"
      mode="$(stat -c '%a' -- "$RESTORE_SCRIPT" 2>/dev/null || echo 777)"
      if [ "$owner" = "0" ] && (( (8#$mode & 022) == 0 )); then safe=1; fi
    fi
    if [ "$safe" = "1" ] && flock -n "$RESTORE_LOCK" timeout 90 bash "$RESTORE_SCRIPT" >/dev/null 2>&1; then
      log "wx-bot unit missing; auto-restore succeeded" '{}'
      sleep 10
    else
      log "wx-bot unit missing; restore skipped or failed safety checks" '{}'
    fi
  fi
fi

if ! raw="$("$WXBOT" inbox count --binding "$BINDING" 2>&1)"; then
  log "wx-bot inbox count failed" '{}'
  silent "wx-bot inbox count failed; skipped this poll" '{}'
else
  count="$(printf '%s' "$raw" | tr -dc '0-9')"
  count="${count:-0}"
  if [ "$count" -gt 0 ]; then
    last_ts=0
    last_count=0
    if [ -f "$WAKE_STATE" ]; then read -r last_ts last_count < "$WAKE_STATE" || true; last_ts="${last_ts:-0}"; last_count="${last_count:-0}"; fi
    if [ "$last_ts" -gt 0 ] && [ $((now - last_ts)) -lt 180 ] && [ "$count" -le "$last_count" ]; then
      silent "message batch already awakened; throttled" '{}'
    else
      if [ "${HATCH_HOOK_DRY_RUN:-0}" != "1" ]; then printf '%s %s\n' "$now" "$count" > "$WAKE_STATE"; fi
      wake "WeChat has $count pending event(s); process using wx-bot instructions" "{\"count\": $count}"
    fi
  elif health_out="$("$WXBOT" health --binding "$BINDING" --liveness 2>&1)"; then
    if [ "${HATCH_HOOK_DRY_RUN:-0}" != "1" ]; then rm -f "$MARK" "$WAKE_STATE"; fi
    silent "wx-bot healthy; no pending messages" '{}'
  else
    health_line="$(printf '%s' "$health_out" | head -1)"
    fresh=0
    if [ -f "$MARK" ] && [ -z "$(find "$MARK" -mmin +60 2>/dev/null)" ]; then fresh=1; fi
    if [ "$fresh" = "1" ]; then
      silent "wx-bot failure already reported within one hour" '{}'
    else
      if [ "${HATCH_HOOK_DRY_RUN:-0}" != "1" ]; then touch "$MARK"; fi
      wake "wx-bot unhealthy: $health_line" '{}'
    fi
  fi
fi
