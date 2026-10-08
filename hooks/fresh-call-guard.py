#!/usr/bin/env python3
"""PreToolUse guard for SendMessage: a finished subagent gets no second round.

Route's rules send every handed-off round, a fix round or a re-review, to a
fresh call. A SendMessage to a finished subagent's raw id ("a" + 16 hex)
carries the old conversation into the new round, so it is refused here, at the
call, where a rule in a document was not enough. Names, sessions ("local_…")
and "main" pass. Input that cannot be read passes too: a guard must never
break a session.

Enable it as a PreToolUse command hook with the matcher "SendMessage" in the
user's settings, pointing at this file in the clone. Test: fresh-call-guard.test.sh.
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
        f'Blocked: "{to}" is a finished subagent. Route\'s rules send every '
        "handed-off round, a fix round or a re-review, to a fresh call: start a "
        "new Agent call whose prompt carries the spec, the findings to fix and "
        "the current diff.\n"
    )
    sys.exit(2)
sys.exit(0)
