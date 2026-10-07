#!/usr/bin/env bash
# A rate-limit effort whose plan was checked before its last commit. That
# commit's title claims S3 is done, but S3's test fails: the 429 response has
# no Retry-After header. A correct check runs the proof, keeps S3 open, keeps
# S1 and S2 ticked, and records the check. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
c() { GIT_AUTHOR_DATE="$1T10:00:00" GIT_COMMITTER_DATE="$1T10:00:00" git commit -qm "$2"; }
add() { git add -A -- . ":!scaffold.sh"; }
mkdir -p limiter tests docs/tickets && : > limiter/__init__.py
printf '__pycache__/\n.pytest_cache/\n' > .gitignore
cat > AGENTS.md <<'EOF'
# api — agent briefing

Tickets: `docs/tickets/`, one markdown file per ticket.
Test: `python3 -m unittest discover -s tests -q`
EOF
cat > limiter/bucket.py <<'EOF'
class Bucket:
    def __init__(self, size):
        self.size, self.tokens = size, size
    def take(self):
        if self.tokens == 0:
            return False
        self.tokens -= 1
        return True
EOF
cat > tests/test_bucket.py <<'EOF'
import unittest
from limiter.bucket import Bucket
class T(unittest.TestCase):
    def test_take(self):
        b = Bucket(1)
        self.assertTrue(b.take())
        self.assertFalse(b.take())
EOF
cat > limiter/limits.py <<'EOF'
from limiter.bucket import Bucket
class Limits:
    def __init__(self, size):
        self.size, self.buckets = size, {}
    def allow(self, user):
        return self.buckets.setdefault(user, Bucket(self.size)).take()
EOF
cat > tests/test_limits.py <<'EOF'
import unittest
from limiter.limits import Limits
class T(unittest.TestCase):
    def test_per_user(self):
        l = Limits(1)
        self.assertTrue(l.allow("a"))
        self.assertTrue(l.allow("b"))
        self.assertFalse(l.allow("a"))
EOF
add && c 2026-10-01 "S1, S2: token bucket and per-user limits"
CHECK=$(git rev-parse --short HEAD)
cat > docs/tickets/T-4-rate-limit.md <<EOF
# T-4: Rate limit the API

Status: open

## Plan
- [x] S1. Token bucket. Proof: \`tests/test_bucket.py\` passes.
- [x] S2. Per-user limits. Proof: \`tests/test_limits.py\` passes.
- [ ] S3. A 429 response with a Retry-After header. Proof: \`tests/test_response.py\` passes.

Checked: 2026-10-02 at $CHECK
EOF
add && c 2026-10-02 "T-4: S1, S2 done"
cat > limiter/response.py <<'EOF'
def too_many(retry_after):
    return {"status": 429, "headers": {}}
EOF
cat > tests/test_response.py <<'EOF'
import unittest
from limiter.response import too_many
class T(unittest.TestCase):
    def test_429(self):
        r = too_many(30)
        self.assertEqual(r["status"], 429)
        self.assertEqual(r["headers"].get("Retry-After"), "30")
EOF
add && c 2026-10-05 "S3: 429 response with Retry-After"
