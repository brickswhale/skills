#!/usr/bin/env bash
# run-route-case.sh <case> <arm: base|skill> <tag> [workdir]
# One fenced run of a route eval case, its outcome grade, then the downstream
# stage (a fresh read-only coordinator) and its grade. Evidence lands in
# <workdir>/runs/<case>-<arm>-<tag>/. Fence: the desktop app's own Claude Code
# binary under `env -i`, which also strips the app's messaging socket that a
# child of an app shell would otherwise inherit; the fixture's bin/ first on
# PATH for the tested session. Needs a stand-alone sign-in (`claude auth login`).
set -u
CASE="$1"; ARM="$2"; TAG="$3"
S="${4:-${TMPDIR:-/tmp}/route-eval}"; mkdir -p "$S/gradedir"
R=$(cd "$(dirname "$0")/.." && pwd)
APPBIN=$(ls -d "$HOME/Library/Application Support/Claude/claude-code/"*/claude.app/Contents/MacOS/claude 2>/dev/null | sort -V | tail -1)
[ -x "$APPBIN" ] || APPBIN=$(command -v claude)
TOOLS="$R/evals"
OUT="$S/runs/$CASE-$ARM-$TAG"; W="$OUT/ws"
rm -rf "$OUT"; mkdir -p "$W"
FENCE=(env -i HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" PATH="$PATH" TMPDIR="$TMPDIR" LANG=en_US.UTF-8 TERM=xterm-256color)
# the tested session and the downstream coordinator find the fixture's stubs first
RUNFENCE=(env -i HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" PATH="$W/bin:$PATH" TMPDIR="$TMPDIR" LANG=en_US.UTF-8 TERM=xterm-256color)
NOTOOLS="Bash,Read,Write,Edit,Glob,Grep,Skill,Agent,WebFetch,WebSearch,SendMessage,ListAgents,NotebookEdit"

cp "$R/evals/$CASE/scaffold.sh" "$W/" && (cd "$W" && bash scaffold.sh > /dev/null; echo $? > "$OUT/scaffold-exit"; rm -f scaffold.sh)
BODY=$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/prompt.md")
MAXT=$(sed -n 's/^max_turns: *//p' "$R/evals/$CASE/prompt.md")
if [ "$ARM" = base ]; then
  PROMPT="${BODY#/brickswhale:route }"
  (cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$PROMPT" --output-format stream-json --verbose --max-turns "$MAXT" \
     --allowedTools "Read,Write,Edit,Bash,Glob,Grep" \
     --disallowedTools "Skill,SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" > "$OUT/run.jsonl" 2> "$OUT/run.err" < /dev/null)
else
  PROMPT="$BODY"
  (cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$PROMPT" --output-format stream-json --verbose --max-turns "$MAXT" --plugin-dir "$R" \
     --allowedTools "Read,Write,Edit,Bash,Glob,Grep,Skill" \
     --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" > "$OUT/run.jsonl" 2> "$OUT/run.err" < /dev/null)
fi

pack() { # evidence for a grader: transcript, diff, final files, logs
  printf '\n=== TRANSCRIPT (numbered, in order) ===\n'; python3 "$TOOLS/condense-transcript.py" "$1"
  printf '\n=== GIT DIFF after the run (tracked files) ===\n'; (cd "$W" && git --no-pager diff)
  printf '\n=== NEW UNTRACKED FILES ===\n'; (cd "$W" && git status --porcelain --untracked-files=all | sed -n 's/^?? //p' | while read -r f; do printf -- '--- %s\n' "$f"; sed -n '1,200p' "$f"; done)
  printf '\n=== STUB LOGS ===\n'; for f in "$W/.machine/plugin-calls.log" "$W/.machine/codex-cli-calls.log" "$W/.machine/claude-cli-calls.log"; do printf -- '--- %s\n' "${f#$W/}"; cat "$f" 2>/dev/null || echo "(none)"; done
}
{ cat "$TOOLS/grader-head.txt"; awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/graders/outcome.md"; pack "$OUT/run.jsonl"; } > "$OUT/outcome.prompt.txt"
(cd "$S/gradedir" && "${FENCE[@]}" "$APPBIN" -p "$(cat "$OUT/outcome.prompt.txt")" --output-format json --max-turns 2 --disallowedTools "$NOTOOLS" > "$OUT/outcome.json" 2>/dev/null < /dev/null)

(cd "$W" && git add -A >/dev/null 2>&1 && git -c user.email=t@t -c user.name=t commit -qm "after the case run" >/dev/null 2>&1)
DPROMPT='A job arrives in `projects/refunds`: build what its `docs/spec.md` asks for. Before anything is handed off, decide who builds it and who reviews it, the way the project'"'"'s routing files ask. Do not dispatch anything and do not change any file: state your decision and stop.'
(cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$DPROMPT" --output-format stream-json --verbose --max-turns 14 \
   --allowedTools "Read,Glob,Grep" --disallowedTools "Bash,Write,Edit,Skill,Agent,SendMessage,ListAgents,NotebookEdit,WebFetch,WebSearch" > "$OUT/down.jsonl" 2>/dev/null < /dev/null)
{ awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/graders/downstream.md"; printf '\n=== TRANSCRIPT ===\n'; python3 "$TOOLS/condense-transcript.py" "$OUT/down.jsonl"; printf '\n=== GIT STATUS (porcelain) ===\n'; (cd "$W" && git status --porcelain); } > "$OUT/down.prompt.txt"
(cd "$S/gradedir" && "${FENCE[@]}" "$APPBIN" -p "$(cat "$OUT/down.prompt.txt")" --output-format json --max-turns 2 --disallowedTools "$NOTOOLS" > "$OUT/down.json" 2>/dev/null < /dev/null)
echo "$CASE $ARM $TAG done"
