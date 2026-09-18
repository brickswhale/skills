#!/usr/bin/env bash
# A repo where the asked-for feature reverses a recorded decision and touches
# three call sites that a file-by-file read would miss. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
printf '# notes — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n' > AGENTS.md
printf '# notes\n\nA tiny note exporter.\n' > README.md
mkdir -p notes tests docs/decisions && : > notes/__init__.py
cat > notes/export.py <<'PY'
import json


def to_json(items):
    return json.dumps(items)
PY
cat > notes/cli.py <<'PY'
from notes.export import to_json


def cmd_show(items):
    return to_json(items)


def cmd_save(items, path):
    with open(path, "w") as f:
        f.write(to_json(items))


def cmd_send(items, client):
    return client.post(to_json(items))
PY
cat > tests/test_export.py <<'PY'
import unittest
from notes.export import to_json


class T(unittest.TestCase):
    def test_json(self):
        self.assertEqual(to_json([{"a": 1}]), '[{"a": 1}]')
PY
cat > docs/decisions/0001-json-only.md <<'MD'
# 0001 — JSON is the only export format

## Status
Accepted

## Date
2026-04-02

## Decision
Notes export as JSON and nothing else. One format keeps the exporter, the
schema and the downstream readers in step.

## Consequences
Any second format means a format-selection surface and a second schema to
keep honest. We accepted losing human-readable output to avoid that.

## Alternatives considered
Markdown export — rejected: no downstream reader asked for it.
MD
printf '| [0001](0001-json-only.md) | JSON is the only export format | Accepted | 2026-04-02 |\n' > docs/decisions/README.md
git add -A -- . ":!scaffold.sh" && git commit -qm "notes: json export"
