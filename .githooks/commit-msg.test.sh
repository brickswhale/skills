#!/usr/bin/env bash
# Regression test for the commit-msg hook.
#
# Why this exists: the hook checked the file on disk rather than the blob staged
# for commit, so an over-cap or non-generic SKILL.md committed cleanly as long as
# the working tree was tidy when the hook ran. It survived an earlier fix to the
# same block, because that one changed the boundary and not the source it read.
# Nothing noticed until a review asked what the hook actually guarantees.
#
# Runs against a throwaway repo in a temp dir, never this one. A harness that
# mutates the thing it tests is how the hook under test once got removed
# mid-run; here an interrupted run can lose nothing.
#
# usage: .githooks/commit-msg.test.sh [path-to-hook]   (exit 0 = all cases pass)
#
# The optional path lets an older hook be run through the same cases, which is
# how this file proved it catches the defect it was written for.
set -u
HOOK="${1:-$(cd "$(dirname "$0")" && pwd)/commit-msg}"
[ -f "$HOOK" ] || { echo "no hook at $HOOK"; exit 1; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
cd "$WORK" || exit 1
git init -q -b main .; git config user.email t@t; git config user.name t
mkdir -p skills/demo evals/demo-fires
BODY=$(python3 -c "print(' '.join(['word']*270))")
printf -- '---\nname: demo\ndescription: a demo skill for the hook test.\n---\n\n# demo\n\n%s\n' "$BODY" > skills/demo/SKILL.md
: > evals/demo-fires/prompt.md
git add -A; git commit -qm init
BASE=$(git show HEAD:skills/demo/SKILL.md | wc -w | tr -d ' ')

MSG="$WORK/msg"
printf 'probe\n\neval-unchanged: isolating rule 1 and rule 3\n' > "$MSG"
F=skills/demo/SKILL.md
pass=0; fail=0

reset() { git reset -q HEAD -- . 2>/dev/null; git checkout -q HEAD -- . 2>/dev/null; }
# restore the WORKING TREE only; `git checkout -- <path>` also rewrites the index
# and would silently undo the very blob a case is trying to stage.
untouch() { git show "HEAD:$F" > "$F"; }
pad() { local n=$1; local i; for ((i=0;i<n;i++)); do printf 'word ' >> "$F"; done; }

check() { # name expected_rc
  local out rc
  out=$(bash "$HOOK" "$MSG" 2>&1); rc=$?
  if [ "$rc" = "$2" ]; then pass=$((pass+1)); printf 'ok   %s\n' "$1"
  else fail=$((fail+1)); printf 'FAIL %s (expected rc=%s, got %s)\n     %s\n' "$1" "$2" "$rc" "$(echo "$out" | head -2 | tr '\n' ' ')"; fi
}

reset; pad $((481-BASE)); git add "$F"; untouch
check "over-cap blob staged, tidy working tree is refused" 1

reset; pad 1; git add "$F"; pad 400
check "compliant blob staged, bloated working tree is allowed" 0

reset; printf '\nsee /Users/someone/notes\n' >> "$F"; git add "$F"; untouch
check "home path in the staged blob is refused" 1

reset; printf '\nbuilt for motion-core\n' >> "$F"; git add "$F"; untouch
check "project name in the staged blob is refused" 1

reset; printf '\napi_key = AKIAsomethinglong123\n' >> "$F"; git add "$F"; untouch
check "credential assignment in the staged blob is refused" 1

reset; pad $((299-BASE)); git add "$F"
check "299 words staged is allowed" 0

reset; pad $((300-BASE)); git add "$F"
check "300 words staged is refused, rule 1 says under 300" 1

reset; git rm -q "$F"
check "staged deletion raises nothing" 0

reset
printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
