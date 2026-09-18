#!/usr/bin/env bash
# A repo with uncommitted work to review: one boundary bug repeated at three call
# sites, an out-of-scope README rewrite, and a test suite that passes anyway.
# Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
printf '# gate — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n' > AGENTS.md
printf '# gate\n\nSession and token checks.\n' > README.md
printf '# Plan: gate\n\n### Task 2 — reject expired credentials\nA credential is expired once `now` is PAST `expires_at`.\nOne exactly AT `expires_at` is still valid and must be accepted.\n\n- [ ] apply the rule at all three call sites\n- [ ] test the exact-boundary case\n- [ ] commit\n' > plan.md
mkdir -p gate tests && : > gate/__init__.py
cat > gate/auth.py <<'PY'
def session_ok(now, expires_at):
    return True


def token_ok(now, expires_at):
    return True


def refresh_ok(now, expires_at):
    return True
PY
cat > tests/test_auth.py <<'PY'
import unittest
from gate.auth import session_ok, token_ok, refresh_ok


class T(unittest.TestCase):
    def test_before_expiry(self):
        self.assertTrue(session_ok(10, 100))
        self.assertTrue(token_ok(10, 100))
        self.assertTrue(refresh_ok(10, 100))
PY
git add -A -- . ":!scaffold.sh" && git commit -qm "gate: stub credential checks"
# the uncommitted work under review
cat > gate/auth.py <<'PY'
def session_ok(now, expires_at):
    return now < expires_at


def token_ok(now, expires_at):
    return now < expires_at


def refresh_ok(now, expires_at):
    return now < expires_at
PY
printf '# gate\n\nThe fastest, friendliest credential gate on the internet. Blazing quick.\nBuilt with love. Session and token checks.\n' > README.md
