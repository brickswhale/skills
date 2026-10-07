#!/usr/bin/env bash
# A date library part-way through a ticket's plan: S1 (month check) is ticked,
# S2 (day check) and S3 (year floor) are open, each with its proof, and the
# list was last checked at the S1 commit. The ask is the next slice. A correct
# run builds S2 only, commits it, then ticks S2 naming that commit, in a
# commit of its own. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
c() { GIT_AUTHOR_DATE="$1T10:00:00" GIT_COMMITTER_DATE="$1T10:00:00" git commit -qm "$2"; }
add() { git add -A -- . ":!scaffold.sh"; }
cat > AGENTS.md <<'MD'
# dates — agent briefing

A tiny date library. Test: `./test.sh`.

Tickets: `docs/tickets/T-<nnnn>.md` (front matter: id, title, status: ready | in_progress | done). Work beyond a typo, comment or format fix follows the `flow` skill: call it before the first edit.
MD
ln -s AGENTS.md CLAUDE.md
mkdir -p docs/tickets src
printf '__pycache__/\n' > .gitignore
printf '# dates\n\nParse and check calendar dates.\n' > README.md
cat > src/parse.py <<'PY'
import datetime


def parse_date(text):
    y, m, d = (int(p) for p in text.split("-"))
    extra_years, m = divmod(m - 1, 12)
    return datetime.date(y + extra_years, m + 1, 1) + datetime.timedelta(days=d - 1)
PY
cat > test.sh <<'SH'
#!/bin/sh
cd "$(dirname "$0")/src" && python3 - <<'PY'
from parse import parse_date
assert str(parse_date("2026-02-03")) == "2026-02-03"
print("ok")
PY
SH
chmod +x test.sh
plan() { cat <<MD
---
id: T-0002
title: parse_date accepts dates that do not exist
status: $1
---

## Problem
\`parse_date\` in \`src/parse.py\` turns a date that does not exist into a real one: "2026-13-01" becomes a date in 2027, "2026-04-31" becomes 1 May, and "1899-12-31" is accepted although the library supports 1900 onwards.

## Plan
- [$2] S1. A month outside 1-12 raises \`ValueError\` — proof: \`./test.sh\` fails if "2026-13-01" is accepted.
- [ ] S2. A day past the month's last day raises \`ValueError\` — proof: \`./test.sh\` fails if "2026-04-31" is accepted.
- [ ] S3. A year before 1900 raises \`ValueError\` — proof: \`./test.sh\` fails if "1899-12-31" is accepted.
$3
## Notes
MD
}
plan ready " " "" > docs/tickets/T-0002.md
add && c 2026-10-01 "dates: parse_date; T-0002 planned"
cat > src/parse.py <<'PY'
import datetime


def parse_date(text):
    y, m, d = (int(p) for p in text.split("-"))
    if not 1 <= m <= 12:
        raise ValueError(f"month out of range: {m}")
    return datetime.date(y, m, 1) + datetime.timedelta(days=d - 1)
PY
cat > test.sh <<'SH'
#!/bin/sh
cd "$(dirname "$0")/src" && python3 - <<'PY'
from parse import parse_date
assert str(parse_date("2026-02-03")) == "2026-02-03"
try:
    parse_date("2026-13-01"); raise SystemExit("FAIL: month 13 accepted")
except ValueError:
    pass
print("ok")
PY
SH
add && c 2026-10-02 "S1: a month outside 1-12 raises ValueError (T-0002)"
S1=$(git rev-parse --short HEAD)
plan in_progress x "
Checked: 2026-10-03 at $S1
" > docs/tickets/T-0002.md
add && c 2026-10-03 "T-0002: S1 checked and ticked"
