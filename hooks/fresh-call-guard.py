#!/usr/bin/env python3
"""PreToolUse guard for SendMessage: a raw subagent id gets no second round.

Route's rules send every handed-off round, a fix round or a re-review, to a
fresh call. A SendMessage to a finished subagent's raw id ("a" + 16 hex)
carries the old conversation into the new round, so it is refused here, at the
call. Names, sessions ("local_…") and "main" pass. Input that cannot be read
passes too: a guard must never break a session.

A backstop, off by default (#28). The cause it met was a session that read the
rules once, before the floor existed; the pointer line now has every round
re-read them. Enable it only if a session that has read the rules still sends a
round to an earlier agent. It cannot tell a finished agent from a running one,
and a named agent passes it. To enable: a PreToolUse command hook with the
matcher "SendMessage" in the user's settings, pointing at this file in the
clone. Test: fresh-call-guard.test.sh.
"""
import json
import re
import sys

SUBAGENT_ID = re.compile(r"^a[0-9a-f]{16}(\s|$)")

try:
    event = json.load(sys.stdin)
except Exception:
    sys.exit(0)
if not isinstance(event, dict) or event.get("tool_name") != "SendMessage":
    sys.exit(0)
to = str((event.get("tool_input") or {}).get("to", "")).strip()
if SUBAGENT_ID.match(to):
    sys.stderr.write(
        f'Blocked: "{to}" is a raw subagent id. Route\'s rules send every '
        "handed-off round, a fix round or a re-review, to a fresh call: start a "
        "new Agent call whose prompt carries the spec, the findings to fix and "
        "the current diff.\n"
    )
    sys.exit(2)
sys.exit(0)
