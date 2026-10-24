#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="$ROOT/config/config.example.json"
python3 - "$CFG" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f: cfg = json.load(f)
assert len(cfg["bindings"]) == 1
binding = cfg["bindings"][0]
assert binding["delivery"] == "pull"
assert binding["allow_wxids"] == ["YOUR_WXID_HERE"]
assert "CHANGE_ME" in cfg["local_api"]["token"]
assert cfg["local_api"]["listen"].startswith("127.0.0.1")
print("config example OK")
PY
grep -q "proxy.example.invalid" "$ROOT/.env.example"
echo "placeholder check OK"
