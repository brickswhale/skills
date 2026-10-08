#!/usr/bin/env bash
# Tests for fresh-call-guard.py: a SendMessage to a finished subagent's raw id is
# refused (exit 2, a reason on stderr); names, sessions, "main", other tools and
# unreadable input pass (exit 0), so the guard never breaks a session.
set -u
dir=$(cd "$(dirname "$0")" && pwd); guard="$dir/fresh-call-guard.py"; fail=0
check() { # <want-exit> <label> <json>
  err=$(printf '%s' "$3" | python3 "$guard" 2>&1 >/dev/null); got=$?
  if [ "$got" != "$1" ]; then echo "FAIL $2: exit $got, want $1"; fail=1; return; fi
  if [ "$1" = 2 ] && ! printf '%s' "$err" | grep -q 'a fresh call'; then echo "FAIL $2: no reason naming a fresh call"; fail=1; return; fi
  echo "ok   $2"
}
msg() { printf '{"hook_event_name":"PreToolUse","tool_name":"%s","tool_input":{"to":"%s","message":"x"}}' "$1" "$2"; }
check 2 "subagent id"            "$(msg SendMessage a0227d050d70f7342)"
check 2 "subagent id with ref"   "$(msg SendMessage 'a0227d050d70f7342 [3fa9c1]')"
check 0 "session id"             "$(msg SendMessage local_0cf782a0-98c3-42f9-b7e1-bdbe89830b30)"
check 0 "main"                   "$(msg SendMessage main)"
check 0 "named teammate"         "$(msg SendMessage researcher)"
check 0 "word that looks close"  "$(msg SendMessage abcdef)"
check 0 "another tool"           "$(msg Bash a0227d050d70f7342)"
check 0 "unreadable input"       "not json"
exit $fail
