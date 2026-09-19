#!/usr/bin/env bash
# Decide whether an eval run is worth grading at all.
#
# Three ways a run produced a normal-looking score today while measuring
# something other than the skill: the plugin manifest was rejected so the skill
# never loaded; the subprocess was killed before it answered; the fixture
# scaffold aborted and the run graded a half-built repo. Each looked fine.
#
# INVALID is void, not red. A void run says nothing about the skill: fix the
# harness and run again, and never fold it into a pass or fail count.
#
# usage: run-valid.sh <skill-name> <run.jsonl> [scaffold-exit-code]
set -u
name="$1"; run="$2"; scaf="${3:-0}"

[ -s "$run" ] || { echo "INVALID: no run file"; exit 1; }

if [ "$scaf" != "0" ]; then
  echo "INVALID: fixture scaffold exited $scaf — the repo under test was not fully built"; exit 1
fi

python3 - "$name" "$run" <<'PY'
import json, sys
name, path = sys.argv[1], sys.argv[2]
init = None; result = None; assistant = 0
for line in open(path):
    try: d = json.loads(line)
    except: continue
    if d.get("subtype") == "init": init = d
    if d.get("type") == "result": result = d
    if d.get("type") == "assistant": assistant += 1

if init is None:
    print("INVALID: no init event — the subprocess never started"); sys.exit(1)
errs = init.get("plugin_errors") or []
if errs:
    print(f"INVALID: plugin_errors {errs[0][:90]} — a rejected manifest loads zero skills"); sys.exit(1)
skills = init.get("skills") or []
if not any(name in s for s in skills):
    print(f"INVALID: {name} not in the session's skills — it graded the bare model"); sys.exit(1)
if result is None:
    print(f"INVALID: no result event after {assistant} assistant turns — killed mid-run"); sys.exit(1)
if result.get("subtype") != "success":
    print(f"INVALID: result subtype {result.get('subtype')}"); sys.exit(1)
if not (result.get("result") or "").strip():
    print("INVALID: empty result text"); sys.exit(1)
print(f"VALID: {name} loaded, {result.get('num_turns')} turns, answered")
PY
