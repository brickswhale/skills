#!/usr/bin/env bash
# A tagging effort whose list names no proof for any item and has never been
# checked: no Checked line. The second item landed with a passing test but
# nobody ticked it; the third has no code. A correct check ticks the second
# item on its test, proposes a proof for each open item, and records the
# check. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
c() { GIT_AUTHOR_DATE="$1T10:00:00" GIT_COMMITTER_DATE="$1T10:00:00" git commit -qm "$2"; }
add() { git add -A -- . ":!scaffold.sh"; }
mkdir -p notes tests docs/tickets && : > notes/__init__.py
printf '__pycache__/\n.pytest_cache/\n' > .gitignore
cat > AGENTS.md <<'EOF'
# notes — agent briefing

Tickets: `docs/tickets/`, one markdown file per ticket.
Test: `python3 -m unittest discover -s tests -q`
EOF
cat > docs/tickets/T-9-tags.md <<'EOF'
# T-9: Tags on notes

Status: open

## Plan
- [ ] Store tags on a note
- [ ] Filter notes by tag
- [ ] Tag chips on the note page
EOF
add && c 2026-09-29 "T-9: plan"
cat > notes/tags.py <<'EOF'
def add_tag(note, tag):
    tags = set(note.get("tags", ()))
    tags.add(tag.strip().lower())
    return {**note, "tags": sorted(tags)}
EOF
cat > tests/test_tags.py <<'EOF'
import unittest
from notes.tags import add_tag
class T(unittest.TestCase):
    def test_add(self):
        n = add_tag(add_tag({"text": "x"}, " Work "), "home")
        self.assertEqual(n["tags"], ["home", "work"])
EOF
add && c 2026-09-30 "tags: store tags on a note"
cat > docs/tickets/T-9-tags.md <<'EOF'
# T-9: Tags on notes

Status: open

## Plan
- [x] Store tags on a note
- [ ] Filter notes by tag
- [ ] Tag chips on the note page
EOF
add && c 2026-09-30 "T-9: storing tags done"
cat > notes/filter.py <<'EOF'
def by_tag(notes, tag):
    tag = tag.strip().lower()
    return [n for n in notes if tag in n.get("tags", ())]
EOF
cat > tests/test_filter.py <<'EOF'
import unittest
from notes.filter import by_tag
class T(unittest.TestCase):
    def test_by_tag(self):
        notes = [{"text": "a", "tags": ["work"]}, {"text": "b", "tags": ["home"]}]
        self.assertEqual(by_tag(notes, "Work"), [notes[0]])
EOF
add && c 2026-10-03 "tags: filter notes by tag"
