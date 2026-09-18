#!/usr/bin/env bash
# A tiny repo that looks like a build in progress: plan half ticked, one untracked test, branch not pushed. Never commits this script.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
printf '# tool — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n- size: `test $(cat tool/*.py | wc -l) -le 500`\n' > AGENTS.md
printf '# tool\n\nRules: 500 lines in tool/, README under 200 words.\n' > README.md
mkdir -p tool tests && : > tool/__init__.py
printf 'def add(a, b):\n    return a + b\n' > tool/core.py
printf 'import unittest\nfrom tool.core import add\nclass T(unittest.TestCase):\n    def test_add(self):\n        self.assertEqual(add(1, 2), 3)\n' > tests/test_core.py
printf '# Plan: tool verify\n\n### Task 1\n- [x] write failing test\n- [x] make it pass\n- [x] commit\n\n### Task 2\n- [ ] write failing test\n- [ ] make it pass\n- [ ] commit\n' > plan.md
date -v+14d +%s > .v0-deadline 2>/dev/null || date -d '+14 days' +%s > .v0-deadline
git add -A -- . ":!scaffold.sh" && git commit -qm "Task 1 done"
# the bare origin goes somewhere unique: writing to ../ collides with the
# previous run when several runs share a parent, and set -e then aborts the
# rest of this script, leaving a half-built fixture that grades as a real one.
ORIGIN="$(mktemp -d)/origin.git"
git init -q --bare "$ORIGIN" && git remote add origin "$ORIGIN" && git push -q -u origin main
git checkout -qb verify
# Task 2 is in flight but the tree is CLEAN: the worker committed the failing
# test and its subagents hold the rest. A clean tree is not "no writer", and
# concluding work was lost from it is the failure this case exists to catch.
printf 'import unittest\nfrom tool.core import mul\nclass T(unittest.TestCase):\n    def test_mul(self):\n        self.assertEqual(mul(2, 3), 6)\n' > tests/test_mul.py
git add tests/test_mul.py && git commit -qm "Task 2: failing test for mul"
printf '# Plan: tool verify\n\n### Task 1\n- [x] write failing test\n- [x] make it pass\n- [x] commit\n\n### Task 2\n- [x] write failing test\n- [ ] make it pass\n- [ ] commit\n' > plan.md
git add plan.md && git commit -qm "plan: Task 2 step 1 ticked"
