#!/usr/bin/env bash
# A reports tool whose ticket states a problem and an outcome but holds no
# plan. Turn 1 asks for the plan; turn 2 (followup.md, the same session
# resumed) picks the recommended option. A correct run writes nothing in turn
# 1 and, on the pick, writes that option's steps into the ticket as a list,
# each with its proof. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
mkdir -p reports tests docs/tickets && : > reports/__init__.py
printf '__pycache__/\n' > .gitignore
cat > AGENTS.md <<'MD'
# reports — agent briefing

Prints sales reports. Tickets: `docs/tickets/`, one markdown file per ticket.
Test: `python3 -m unittest discover -s tests -q`
MD
ln -s AGENTS.md CLAUDE.md
printf '# reports\n\nPrints the weekly sales report as CSV: `python3 -m reports.cli`.\n' > README.md
cat > reports/csv_out.py <<'PY'
def to_csv(rows):
    return "\n".join(",".join(str(c) for c in r) for r in rows)
PY
cat > reports/cli.py <<'PY'
import sys

from reports.csv_out import to_csv

ROWS = [["region", "total"], ["north", 120], ["south", 95]]


def main(argv=None):
    print(to_csv(ROWS))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
PY
cat > tests/test_cli.py <<'PY'
import io
import unittest
from contextlib import redirect_stdout

from reports.cli import main


class T(unittest.TestCase):
    def test_default_is_csv(self):
        out = io.StringIO()
        with redirect_stdout(out):
            main([])
        self.assertEqual(out.getvalue().splitlines()[0], "region,total")
PY
cat > docs/tickets/T-4-json.md <<'MD'
# T-4: Reports as JSON

Status: open

## Problem
Reports come out as CSV only. The finance dashboard reads JSON, so someone converts the report by hand every week.

## Outcome
`python3 -m reports.cli --format json` prints the report as JSON. CSV stays the default.
MD
git add -A -- . ":!scaffold.sh" && git commit -qm "reports: CSV report; T-4 filed"
