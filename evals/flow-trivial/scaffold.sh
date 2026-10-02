#!/usr/bin/env bash
# The flow-fires repo, with a typo in README.md. A typo fix is the fast lane:
# it must make no ticket and touch none. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
cat > AGENTS.md <<'MD'
# dates — agent briefing

A tiny date library. Test: `./test.sh`. Every commit adds a line to `docs/devlog.md`.

Tickets: `docs/tickets/T-<nnnn>.md` (front matter: id, title, status: ready | in_progress | done). Work beyond a typo, comment or format fix follows the `flow` skill: call it before the first edit.
MD
ln -s AGENTS.md CLAUDE.md
mkdir -p docs/tickets src
printf '# dates\n\nParse calendar dates and recieve a clear error for a bad one.\n' > README.md
printf '# Dev log\n\n- 2026-09-30 init: parse_date and is_leap.\n' > docs/devlog.md
cat > docs/tickets/T-0001.md <<'MD'
---
id: T-0001
title: parse_date accepts month 13
status: ready
---

## Problem
`parse_date` in `src/parser.py` accepts "2026-13-01" and returns a date in the next year.

## Acceptance
- A month outside 1-12 raises `ValueError`.
- `./test.sh` passes.

## Notes
MD
cat > src/parse.py <<'PY'
import datetime


def is_leap(y):
    return y % 4 == 0


def parse_date(text):
    y, m, d = (int(p) for p in text.split("-"))
    extra_years, m = divmod(m - 1, 12)
    return datetime.date(y + extra_years, m + 1, d)
PY
cat > test.sh <<'SH'
#!/bin/sh
cd "$(dirname "$0")/src" && python3 - <<'PY'
from parse import parse_date, is_leap
assert str(parse_date("2026-02-03")) == "2026-02-03"
try:
    parse_date("2026-13-01"); raise SystemExit("FAIL: month 13 accepted")
except ValueError:
    pass
if is_leap(1900):
    print("NOTE: is_leap(1900) is True, but 1900 was not a leap year")
print("ok")
PY
SH
chmod +x test.sh
git add -A && git commit -qm init
