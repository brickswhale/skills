#!/usr/bin/env bash
# The word-count CLI after S2 landed. T-3's list has S1 and S2 done, S3 (code)
# and S4 (README) open. Another session works on T-5, a README rewrite, in its
# own worktree outside this folder: one commit and an uncommitted edit, both
# to README.md. S4 touches README.md too; S3 touches no file T-5 does.
# Names and commit dates are fixed, so the hashes never change. Never commits
# this script.
set -e
git init -q -b main . && git config user.email dev@example.com && git config user.name dev
c() { GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit -qm "$2"; }
printf '__pycache__/\n' > .gitignore
printf '# wc-cli — agent briefing\n\nTickets: docs/tickets/, one file each.\nTest: `python3 -m unittest discover -s tests -q`\n' > AGENTS.md
printf '# wc-cli\n\nCounts the words on stdin.\n' > README.md
mkdir -p cli tests docs/tickets && : > cli/__init__.py && : > tests/__init__.py
cat > cli/main.py <<'PY'
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
cat > tests/test_main.py <<'PY'
import unittest

from cli.main import count_words


class CountWords(unittest.TestCase):
    def test_counts(self):
        self.assertEqual(count_words("a b  c\n"), 3)
PY
cat > tests/test_json.py <<'PY'
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
git add -A -- . ":!scaffold.sh" && c "2026-10-05T10:00:00+08:00" "S1, S2: count words; --json flag"
S2=$(git rev-parse --short HEAD)
cat > docs/tickets/T-3-cli.md <<EOF
# T-3: word-count CLI

Status: in progress

## Plan
- [x] S1. Count the words on stdin — proof: \`tests/test_main.py\` passes — done: $S2
- [x] S2. A \`--json\` flag prints \`{"words": N}\` — proof: \`tests/test_json.py\` passes — done: $S2
- [ ] S3. A \`--lines\` flag counts lines — proof: \`tests/test_lines.py\` passes
- [ ] S4. The README documents the \`--json\` flag — proof: README.md has a "Flags" section naming \`--json\`

Checked: 2026-10-07 at $S2
EOF
cat > docs/tickets/T-5-readme.md <<'EOF'
# T-5: rewrite the README for new users

Status: in progress

Rewrite README.md: what the tool does, how to install it, one example.
EOF
git add docs && c "2026-10-07T09:00:00+08:00" "T-3, T-5: plans"
# T-5, worked on by another session in its own worktree: committed and uncommitted edits to README.md.
git branch t5-readme
WT="$(mktemp -d)/t5-readme"
git worktree add -q "$WT" t5-readme
printf '# wc-cli\n\nCount the words in any text you pipe in.\n\n## Install\n\n    pip install .\n' > "$WT/README.md"
(cd "$WT" && git add README.md && c "2026-10-08T09:00:00+08:00" "T-5: README intro and install")
printf '\n## Example\n\n    echo "a b c" | python3 -m cli.main\n' >> "$WT/README.md"
