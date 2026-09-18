#!/usr/bin/env bash
# A repo whose history shows one defect patched a site at a time, a briefing
# carrying a line too vague to have stopped it, and both a test suite and a
# hooks directory available as stronger rungs. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
mkdir -p feed tests .githooks && : > feed/__init__.py
printf '# feed — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n- hooks live in `.githooks/`, installed with `git config core.hooksPath .githooks`\n\nRules:\n- Be thorough when fixing bugs.\n- Keep the parser pure: no I/O in `feed/parse.py`.\n' > AGENTS.md
printf '# feed\n\nParses feed timestamps.\n' > README.md
printf '#!/bin/sh\n# no checks yet\nexit 0\n' > .githooks/pre-commit && chmod +x .githooks/pre-commit
cat > feed/parse.py <<'PY'
from datetime import datetime


def parse_published(s):
    return datetime.fromisoformat(s)


def parse_updated(s):
    return datetime.fromisoformat(s)


def parse_expires(s):
    return datetime.fromisoformat(s)


def parse_fetched(s):
    return datetime.fromisoformat(s)
PY
cat > tests/test_parse.py <<'PY'
import unittest
from feed.parse import parse_published


class T(unittest.TestCase):
    def test_parses(self):
        self.assertEqual(parse_published("2026-01-01T00:00:00").year, 2026)
PY
git add -A -- . ":!scaffold.sh" && git commit -qm "feed: parse timestamps"
# three weeks of patching one site at a time
python3 - <<'PY'
import re, pathlib
p = pathlib.Path("feed/parse.py"); t = p.read_text()
t = t.replace('def parse_published(s):\n    return datetime.fromisoformat(s)',
              'def parse_published(s):\n    return datetime.fromisoformat(s).astimezone(timezone.utc)')
t = t.replace('from datetime import datetime', 'from datetime import datetime, timezone')
p.write_text(t)
PY
git commit -qam "fix: parse_published lost the timezone"
python3 - <<'PY'
import pathlib
p = pathlib.Path("feed/parse.py"); t = p.read_text()
t = t.replace('def parse_updated(s):\n    return datetime.fromisoformat(s)',
              'def parse_updated(s):\n    return datetime.fromisoformat(s).astimezone(timezone.utc)')
p.write_text(t)
PY
git commit -qam "fix: parse_updated lost the timezone too"
python3 - <<'PY'
import pathlib
p = pathlib.Path("feed/parse.py"); t = p.read_text()
t = t.replace('def parse_expires(s):\n    return datetime.fromisoformat(s)',
              'def parse_expires(s):\n    return datetime.fromisoformat(s).astimezone(timezone.utc)')
p.write_text(t)
PY
git commit -qam "fix: parse_expires, same timezone bug"
