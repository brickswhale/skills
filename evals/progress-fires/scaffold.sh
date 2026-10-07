#!/usr/bin/env bash
# An export effort part-way through. Its plan was last checked at the commit
# "S2: json export". After that check, S2 was reverted, S3 landed without
# anyone ticking it, and a TSV export landed that the plan never listed.
# A correct check unticks S2, ticks S3 and proposes the TSV export.
# Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
c() { GIT_AUTHOR_DATE="$1T10:00:00" GIT_COMMITTER_DATE="$1T10:00:00" git commit -qm "$2"; }
add() { git add -A -- . ":!scaffold.sh"; }
mkdir -p exporter tests docs/tickets && : > exporter/__init__.py
printf '__pycache__/\n.pytest_cache/\n' > .gitignore
cat > AGENTS.md <<'EOF'
# exporter — agent briefing

Tickets: `docs/tickets/`, one markdown file per ticket.
Test: `python3 -m unittest discover -s tests -q`
EOF
printf '# exporter\n\nTurns report rows into files.\n' > README.md
cat > exporter/csv_out.py <<'EOF'
def to_csv(rows):
    return "\n".join(",".join(str(c) for c in r) for r in rows)
EOF
cat > tests/test_csv.py <<'EOF'
import unittest
from exporter.csv_out import to_csv
class T(unittest.TestCase):
    def test_csv(self):
        self.assertEqual(to_csv([[1, 2], [3, 4]]), "1,2\n3,4")
EOF
cat > docs/tickets/T-7-export.md <<'EOF'
# T-7: Export reports

Status: open

## Plan
- [ ] S1. CSV export. Proof: `tests/test_csv.py` passes.
- [ ] S2. JSON export. Proof: `tests/test_json.py` passes.
- [ ] S3. Date filter on exports. Proof: `tests/test_filter.py` passes.
- [ ] S4. README section "Export". Proof: `README.md` has a heading "Export".
EOF
add && c 2026-09-29 "T-7: plan; S1 csv export"
cat > exporter/json_out.py <<'EOF'
import json
def to_json(rows):
    return json.dumps(rows)
EOF
cat > tests/test_json.py <<'EOF'
import unittest
from exporter.json_out import to_json
class T(unittest.TestCase):
    def test_json(self):
        self.assertEqual(to_json([[1, 2]]), "[[1, 2]]")
EOF
add && c 2026-09-30 "S2: json export"
CHECK=$(git rev-parse --short HEAD)
cat > docs/tickets/T-7-export.md <<EOF
# T-7: Export reports

Status: open

## Plan
- [x] S1. CSV export. Proof: \`tests/test_csv.py\` passes.
- [x] S2. JSON export. Proof: \`tests/test_json.py\` passes.
- [ ] S3. Date filter on exports. Proof: \`tests/test_filter.py\` passes.
- [ ] S4. README section "Export". Proof: \`README.md\` has a heading "Export".

Checked: 2026-10-01 at $CHECK
EOF
add && c 2026-10-01 "T-7: S1, S2 done"
git rm -q exporter/json_out.py tests/test_json.py && c 2026-10-02 'Revert "S2: json export": it broke the nightly job'
cat > exporter/date_filter.py <<'EOF'
def between(rows, start, end):
    return [r for r in rows if start <= r[0] <= end]
EOF
cat > tests/test_filter.py <<'EOF'
import unittest
from exporter.date_filter import between
class T(unittest.TestCase):
    def test_between(self):
        rows = [["2026-01-01", 1], ["2026-02-01", 2], ["2026-03-01", 3]]
        self.assertEqual(between(rows, "2026-01-15", "2026-02-15"), [["2026-02-01", 2]])
EOF
add && c 2026-10-03 "S3: date filter on exports"
cat > exporter/tsv_out.py <<'EOF'
def to_tsv(rows):
    return "\n".join("\t".join(str(c) for c in r) for r in rows)
EOF
cat > tests/test_tsv.py <<'EOF'
import unittest
from exporter.tsv_out import to_tsv
class T(unittest.TestCase):
    def test_tsv(self):
        self.assertEqual(to_tsv([[1, 2]]), "1\t2")
EOF
add && c 2026-10-04 "TSV export for the finance team"
