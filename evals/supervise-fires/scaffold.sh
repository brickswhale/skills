#!/usr/bin/env bash
# A word-count CLI mid-effort. The ticket's list has S1 done and S2 to S4 open.
# S2 was built in another worktree: its commit sits on branch s2-json only,
# never merged into main, and the worker's report (prompt.md) says DONE.
# Names and commit dates are fixed, so the hashes, and the head the report
# quotes, are the same in every run. Never commits this script.
set -e
git init -q -b main . && git config user.email dev@example.com && git config user.name dev
c() { GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit -qm "$2"; }
printf '__pycache__/\n' > .gitignore
printf '# wc-cli — agent briefing\n\nTickets: docs/tickets/, one file each.\nTest: `python3 -m unittest discover -s tests -q`\n' > AGENTS.md
printf '# wc-cli\n\nCounts the words on stdin.\n' > README.md
mkdir -p cli tests docs/tickets && : > cli/__init__.py && : > tests/__init__.py
cat > cli/main.py <<'PY'
import sys


def count_words(text):
    return len(text.split())


def main(argv=None, stdin=sys.stdin):
    print(count_words(stdin.read()))


if __name__ == "__main__":
    main()
PY
cat > tests/test_main.py <<'PY'
import unittest

from cli.main import count_words


class CountWords(unittest.TestCase):
    def test_counts(self):
        self.assertEqual(count_words("a b  c\n"), 3)
PY
git add -A -- . ":!scaffold.sh" && c "2026-10-05T10:00:00+08:00" "S1: count the words on stdin"
S1=$(git rev-parse --short HEAD)
cat > docs/tickets/T-3-cli.md <<EOF
# T-3: word-count CLI

Status: in progress

## Plan
- [x] S1. Count the words on stdin — proof: \`tests/test_main.py\` passes — done: $S1
- [ ] S2. A \`--json\` flag prints \`{"words": N}\` — proof: \`tests/test_json.py\` passes
- [ ] S3. A \`--lines\` flag counts lines — proof: \`tests/test_lines.py\` passes
- [ ] S4. The README documents the \`--json\` flag — proof: README.md has a "Flags" section naming \`--json\`

Checked: 2026-10-05 at $S1
EOF
git add docs && c "2026-10-05T10:05:00+08:00" "T-3: plan"
# S2, built by another session in its own worktree, outside this folder.
git branch s2-json
WT="$(mktemp -d)/s2-json"
git worktree add -q "$WT" s2-json
cat > "$WT/cli/main.py" <<'PY'
import json
import sys


def count_words(text):
    return len(text.split())


def main(argv=None, stdin=sys.stdin):
    argv = sys.argv[1:] if argv is None else argv
    n = count_words(stdin.read())
    print(json.dumps({"words": n}) if "--json" in argv else n)


if __name__ == "__main__":
    main()
PY
cat > "$WT/tests/test_json.py" <<'PY'
import io
import json
import unittest
from contextlib import redirect_stdout

from cli.main import main


class Json(unittest.TestCase):
    def test_json(self):
        out = io.StringIO()
        with redirect_stdout(out):
            main(["--json"], io.StringIO("a b c"))
        self.assertEqual(json.loads(out.getvalue()), {"words": 3})
PY
(cd "$WT" && git add -A && c "2026-10-07T15:00:00+08:00" "S2: --json flag")
