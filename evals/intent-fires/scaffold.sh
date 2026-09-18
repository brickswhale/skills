#!/usr/bin/env bash
# A repo that already answers two of the questions a lazy interview would ask the
# user: the latency budget and a recorded decision banning the obvious fix.
# Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
printf '# shelf — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n\nBudgets:\n- list endpoint p95 must stay under 300ms\n' > AGENTS.md
printf '# shelf\n\nA small catalogue API.\n' > README.md
mkdir -p api tests docs/decisions && : > api/__init__.py
cat > api/list.py <<'PY'
from api.store import fetch_item, fetch_ids


def list_items(user):
    out = []
    for i in fetch_ids(user):
        out.append(fetch_item(i))
    return out
PY
cat > api/store.py <<'PY'
def fetch_ids(user):
    return []


def fetch_item(item_id):
    return {"id": item_id}
PY
cat > api/web.py <<'PY'
from api.list import list_items


def get_list(user):
    return list_items(user)


def get_export(user):
    return list_items(user)
PY
cat > tests/test_list.py <<'PY'
import unittest
from api.list import list_items


class T(unittest.TestCase):
    def test_empty(self):
        self.assertEqual(list_items("u"), [])
PY
cat > docs/decisions/0001-no-cache.md <<'MD'
# 0001 — No caching layer

## Status
Accepted

## Date
2026-03-11

## Decision
The catalogue serves from the store on every request. No cache, no read
replica. Stale shelf data is worse than a slow shelf.

## Consequences
Latency work has to come from the query path itself.
MD
printf '| [0001](0001-no-cache.md) | No caching layer | Accepted | 2026-03-11 |\n' > docs/decisions/README.md
git add -A -- . ":!scaffold.sh" && git commit -qm "shelf: catalogue api"
