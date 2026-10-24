#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in "$ROOT"/scripts/*.sh; do
  bash -n "$script"
  echo "syntax OK: ${script#"$ROOT"/}"
done
bash "$ROOT/scripts/audit-public-tree.sh" "$ROOT"
echo "audit test OK"
