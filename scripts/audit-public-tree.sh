#!/usr/bin/env bash
# Best-effort scan of a public source tree. This is not a proof of safety.
set -u
ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
fail=0
for pat in 'config.json' '.env' '*.db' '*.db-shm' '*.db-wal' '*.log' '*.pem' '*.key' 'inbox.db' 'release-checksums.txt'; do
  while IFS= read -r f; do
    case "$f" in */config.example.json|*/.env.example) continue ;; esac
    echo "FORBIDDEN FILE: $f"; fail=1
  done < <(find "$ROOT" -name "$pat" -type f 2>/dev/null)
done
check() {
  local label="$1" regex="$2"
  while IFS= read -r hit; do echo "SUSPICIOUS [$label]: $hit"; fail=1; done < <(grep -rInE "$regex" "$ROOT" --exclude-dir=.git 2>/dev/null | cut -d: -f1-2)
}
check "credential-key" '(bot_token|refresh_token|access_token|api[_-]?key|client_secret)[[:space:]]*[:=]'
check "wechat-id" '[A-Za-z0-9_-]{20,}@im\.wechat'
check "google-doc-link" 'docs\.google\.com/document/d/[A-Za-z0-9_-]{20,}'
check "private-key-block" '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
check "credentialed-url" '://[^/:[:space:]]+:[^@[:space:]]+@'
while IFS= read -r f; do
  if grep -E '/home/[A-Za-z0-9_.-]+' "$f" 2>/dev/null | grep -v '/home/USER' | grep -q .; then echo "SUSPICIOUS [real-home-path]: $f"; fail=1; fi
done < <(grep -rlE '/home/[A-Za-z0-9_.-]+' "$ROOT" --exclude-dir=.git 2>/dev/null)
if [ "$fail" -eq 0 ]; then echo "audit clean: $ROOT"; else echo "audit FAILED"; fi
exit "$fail"
