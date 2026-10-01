#!/usr/bin/env bash
# run-route-case.sh <case> <arm: base|skill> <tag> [workdir]
# One fenced run of a route eval case, its outcome grade, then the downstream
# stage (a fresh read-only coordinator) and its grade. Evidence lands in
# <workdir>/runs/<case>-<arm>-<tag>/. Fence: the desktop app's own Claude Code
# binary under `env -i`, which also strips the app's messaging socket that a
# child of an app shell would otherwise inherit; the fixture's bin/ first on
# PATH for the tested session. Needs a stand-alone sign-in (`claude auth login`).
# GRADE_ONLY=1 re-grades a saved run: no scaffold, no tested session.
# Judges run on the default model and effort; ROUTE_JUDGE_MODEL picks another
# (at low effort). Cheaper judges were tried and misgraded, see route-design.md.
set -u
CASE="$1"; ARM="$2"; TAG="$3"
S="${4:-${TMPDIR:-/tmp}/route-eval}"; mkdir -p "$S/gradedir"
R=$(cd "$(dirname "$0")/.." && pwd)
APPBIN=$(ls -d "$HOME/Library/Application Support/Claude/claude-code/"*/claude.app/Contents/MacOS/claude 2>/dev/null | sort -V | tail -1)
[ -x "$APPBIN" ] || APPBIN=$(command -v claude)
TOOLS="$R/evals"
OUT="$S/runs/$CASE-$ARM-$TAG"; W="$OUT/ws"
GRADE_ONLY="${GRADE_ONLY:-}"
JUDGE=(); [ -n "${ROUTE_JUDGE_MODEL:-}" ] && JUDGE=(--model "$ROUTE_JUDGE_MODEL" --effort low)
if [ -z "$GRADE_ONLY" ]; then rm -rf "$OUT"; mkdir -p "$W"
else
  [ -s "$OUT/run.jsonl" ] || { echo "GRADE_ONLY: no saved run in $OUT"; exit 1; }
  # undo the post-run commit, keep its files, so the grader sees the run's diff
  [ "$(cd "$W" && git log -1 --format=%s)" = "after the case run" ] && (cd "$W" && git reset -q HEAD~1)
fi
FENCE=(env -i HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" PATH="$PATH" TMPDIR="$TMPDIR" LANG=en_US.UTF-8 TERM=xterm-256color)
# The tested session and the downstream coordinator see the fixture's bin/ and
# the system directories only: a PATH that fell through to the real machine's
# printed its real node from a stand-in machine (17 of 35 command runs).
RUNFENCE=(env -i HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" PATH="$W/bin:/usr/bin:/bin:/usr/sbin:/sbin" TMPDIR="$TMPDIR" LANG=en_US.UTF-8 TERM=xterm-256color)
NOTOOLS="Bash,Read,Write,Edit,Glob,Grep,Skill,Agent,WebFetch,WebSearch,SendMessage,ListAgents,NotebookEdit"

[ -z "$GRADE_ONLY" ] && cp "$R/evals/$CASE/scaffold.sh" "$W/" && (cd "$W" && bash scaffold.sh > /dev/null; echo $? > "$OUT/scaffold-exit"; rm -f scaffold.sh)
# The stand-in machine's node: a copy-on-write clone of the real one (the Codex
# call shape runs node), kept out of the workspace's git so no diff shows it.
[ -z "$GRADE_ONLY" ] && cp -c "$(command -v node)" "$W/bin/node" && echo bin/node >> "$W/.git/info/exclude"
BODY=$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/prompt.md")
MAXT=$(sed -n 's/^max_turns: *//p' "$R/evals/$CASE/prompt.md")
if [ -n "$GRADE_ONLY" ]; then :
elif [ "$ARM" = base ]; then
  PROMPT="${BODY#/route }"
  (cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$PROMPT" --output-format stream-json --verbose --max-turns "$MAXT" \
     --allowedTools "Read,Write,Edit,Bash,Glob,Grep" \
     --disallowedTools "Skill,SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" > "$OUT/run.jsonl" 2> "$OUT/run.err" < /dev/null)
else
  PROMPT="$BODY"
  (cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$PROMPT" --output-format stream-json --verbose --max-turns "$MAXT" --plugin-dir "$R" \
     --allowedTools "Read,Write,Edit,Bash,Glob,Grep,Skill" \
     --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" > "$OUT/run.jsonl" 2> "$OUT/run.err" < /dev/null)
fi

# Runtime proof of loading, both arms. Claude Code's own session transcript
# records a slash command's first user turn with <command-name> and the
# command's full text; stream-json never echoes that turn, and a marker line in
# the output proves nothing (a run can load the command and skip the marker, or
# imitate it without loading). Found by session id: the downstream stage below
# runs in the same directory and writes its own transcript there too.
python3 - "$OUT/run.jsonl" "$W" "$R/skills/route/SKILL.md" > "$OUT/loaded.txt" <<'PYEOF'
import json, os, re, sys
run, ws, skill = sys.argv[1:4]
sid = None
for line in open(run):
    try: d = json.loads(line)
    except ValueError: continue
    if d.get("type") == "system" and d.get("subtype") == "init":
        sid = d.get("session_id"); break
body = open(skill).read().split("\n# route\n", 1)[1]
mark = next(l.strip() for l in body.splitlines() if l.strip())
path = os.path.join(os.path.expanduser("~/.claude/projects"), re.sub(r"[/.]", "-", ws), f"{sid}.jsonl")
if not sid or not os.path.exists(path):
    print(f"NO TRANSCRIPT: {'no session id' if not sid else 'missing ' + os.path.basename(path)}"); sys.exit()
# The expansion spans the user turns before the first reply: the command's
# name in one, its text in the next.
opening = []
for line in open(path):
    try: d = json.loads(line)
    except ValueError: continue
    if d.get("type") == "assistant": break
    if d.get("type") == "user":
        c = d.get("message", {}).get("content")
        opening.append(c if isinstance(c, str) else json.dumps(c))
s = "\n".join(opening)
tag = "<command-name>/route</command-name>" in s
print("LOADED: /route expanded, its text before the first reply" if tag and mark in s else
      f"NOT LOADED: {'/route named but its text absent' if tag else 'no /route command'} before the first reply")
PYEOF

# The fence, checked mechanically: judges missed a real path in tool output
# 16 times of 17. Allowed outside the workspace: the command's own files and
# Claude Code's own projects directory (owner's rulings, 2026-09-28).
python3 - "$OUT/run.jsonl" "$W" "$R" > "$OUT/fence.txt" <<'PYEOF'
import json, os, re, sys
run, ws, repo = sys.argv[1:4]; home = os.path.expanduser("~")
allowed = [ws, os.path.realpath(ws), os.path.join(home, ".claude/projects"),
           os.path.join(repo, "skills/route"), os.path.join(repo, "skills/pair/references")]
allowed += [os.path.join(home, d, "skills", s) for d in (".claude", ".agents") for s in ("route", "pair/references")]
# a listing of the pair skill's own folder shows only file names (owner, 2026-09-30); its files stay outside
exact = [os.path.join(b, "pair") for b in (os.path.join(home, ".claude/skills"), os.path.join(home, ".agents/skills"), os.path.join(repo, "skills"))]
exact += [e + "/" for e in exact]
pat = re.compile(r"(?:%s|/opt/homebrew|/usr/local)[^\s\"'`:;|&)]*" % re.escape(home))
bad = set()
def scan(text):
    for m in pat.findall(text):
        # a copy of an allowed path cut off mid-name (a wrapped or truncated line) names
        # nothing outside; a whole folder above one (e.g. the home directory) still counts
        if not m.endswith("/") and any(a.startswith(m) and len(a) > len(m) and a[len(m)] != "/" for a in allowed): continue
        if m not in exact and not any(m == a or m.startswith(a + "/") for a in allowed): bad.add(m)
for line in open(run):
    try: d = json.loads(line)
    except ValueError: continue
    content = (d.get("message") or {}).get("content")
    if not isinstance(content, list): continue
    for c in content:
        if c.get("type") == "tool_use":
            i = c.get("input", {})
            probe = " ".join(str(i.get(k, "")) for k in ("command", "file_path", "path", "pattern"))
            scan(probe)
            # ~ and $HOME name the home directory: expand, then judge like any path.
            # A ~ counts only where the shell expands it, at the start of a word;
            # awk's match operator (`$1 ~ /re/`, `a[i]~/re/`) is not a path.
            for m in re.findall(r"(?:(?<![^\s=:'\"(])~(?!\s+/)|\$HOME|\$\{HOME\})(?:/[^\s\"'`:;|&)]*)?", str(i.get("command", ""))):
                full = re.sub(r"^(?:~|\$HOME|\$\{HOME\})", home, m)
                if full not in exact and not any(full == a or full.startswith(a + "/") for a in allowed): bad.add(m)
        elif c.get("type") == "tool_result":
            r = c.get("content"); scan(r if isinstance(r, str) else json.dumps(r))
print("FENCE BREACH: " + ", ".join(sorted(bad)) if bad else "FENCE OK")
PYEOF

# The footprint, checked mechanically (rule 9): the command writes the registry
# and the policy under the machine's config directory, and in a project nothing
# but a pointer line in its briefing. size.txt gives the policy's word count; it
# gates nothing. A committed file naming an absolute home path is flagged.
python3 - "$W" > "$OUT/footprint.txt" 2> "$OUT/size.txt" <<'PYEOF'
import os, re, subprocess, sys
ws = sys.argv[1]
git = lambda *a: subprocess.run(["git", *a], cwd=ws, capture_output=True, text=True).stdout
home = re.compile(r"/(Users|home)/[^/\s]+")
flags, sizes = [], []
for line in git("status", "--porcelain", "--untracked-files=all").splitlines():
    code, path = line[:2].strip(), line[3:].split(" -> ")[-1]
    full = os.path.join(ws, path)
    if path.startswith(".machine/route/"):
        if "policy" in os.path.basename(path) and os.path.exists(full):
            sizes.append(f"{path}: {len(open(full).read().split())} words")
        continue
    m = re.match(r"projects/([^/]+)/(AGENTS|CLAUDE)\.md$", path)
    if not m:
        flags.append(f"{code} {path}"); continue
    if code == "??":
        added, removed = len(open(full).read().splitlines()), 0
    else:
        stat = git("diff", "--numstat", "--", path).split()
        added, removed = (int(stat[0]), int(stat[1])) if stat else (0, 0)
    if removed or added > 2:
        flags.append(f"{path}: +{added} -{removed}, one pointer line expected")
    if os.path.exists(full) and home.search(git("diff", "--", path) if code != "??" else open(full).read()):
        flags.append(f"{path}: an absolute home path")
print("FOOTPRINT FLAG: " + "; ".join(flags) if flags else "FOOTPRINT OK")
sys.stderr.write("\n".join(sizes) + "\n")
PYEOF

pack() { # evidence for a grader: transcript, diff, final files, logs
  printf '\n=== TRANSCRIPT (numbered, in order) ===\n'; python3 "$TOOLS/condense-transcript.py" "$1"
  printf '\n=== GIT DIFF after the run (tracked files) ===\n'; (cd "$W" && git --no-pager diff)
  printf '\n=== NEW UNTRACKED FILES ===\n'; (cd "$W" && git status --porcelain --untracked-files=all | sed -n 's/^?? //p' | while read -r f; do printf -- '--- %s\n' "$f"; sed -n '1,200p' "$f"; done)
  printf '\n=== STUB LOGS ===\n'; for f in "$W/.machine/plugin-calls.log" "$W/.machine/codex-cli-calls.log" "$W/.machine/claude-cli-calls.log"; do printf -- '--- %s\n' "${f#$W/}"; cat "$f" 2>/dev/null || echo "(none)"; done
}
{ cat "$TOOLS/grader-head.txt"; awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/graders/outcome.md"; pack "$OUT/run.jsonl"; } > "$OUT/outcome.prompt.txt"
(cd "$S/gradedir" && "${FENCE[@]}" "$APPBIN" -p "$(cat "$OUT/outcome.prompt.txt")" ${JUDGE[@]+"${JUDGE[@]}"} --output-format json --max-turns 2 --disallowedTools "$NOTOOLS" > "$OUT/outcome.json" 2>/dev/null < /dev/null)

if [ "$ARM" = skill ]; then
  # the command arm only: was the skill loaded, and did its body run?
  bash "$R/evals/run-valid.sh" route "$OUT/run.jsonl" "$(cat "$OUT/scaffold-exit")" > "$OUT/valid.txt" 2>&1
fi
(cd "$W" && git add -A >/dev/null 2>&1 && git -c user.email=t@t -c user.name=t commit -qm "after the case run" >/dev/null 2>&1)
# No downstream stage for a run that already failed its outcome: acceptance
# needs both, so a failed outcome settles the run.
if python3 -c 'import json,re,sys; r=json.load(open(sys.argv[1])).get("result",""); sys.exit(0 if re.search(r"\"verdict\": *\"FAIL\"",r) else 1)' "$OUT/outcome.json" 2>/dev/null; then
  rm -f "$OUT"/down.jsonl "$OUT"/down.prompt.txt "$OUT"/down.json "$OUT"/down2.jsonl "$OUT"/down2.prompt.txt "$OUT"/down2.json; echo "$CASE $ARM $TAG done (outcome FAIL, no downstream)"; exit 0
fi
# Two downstream stages, each a fresh read-only coordinator: the money job,
# and an ordinary job that must be routed, not stopped.
downstream() { # <tag> <spec file> <grader>
  local DP='A job arrives in `projects/refunds`: build what its `docs/'"$2"'` asks for. Before anything is handed off, decide who builds it and who reviews it, the way the project'"'"'s routing files ask. Do not dispatch anything and do not change any file: state your decision and stop.'
  (cd "$W" && "${RUNFENCE[@]}" "$APPBIN" -p "$DP" --output-format stream-json --verbose --max-turns 14 \
     --allowedTools "Read,Glob,Grep" --disallowedTools "Bash,Write,Edit,Skill,Agent,SendMessage,ListAgents,NotebookEdit,WebFetch,WebSearch" > "$OUT/$1.jsonl" 2>/dev/null < /dev/null)
  { awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$R/evals/$CASE/graders/$3"; printf '\n=== TRANSCRIPT ===\n'; python3 "$TOOLS/condense-transcript.py" "$OUT/$1.jsonl"; printf '\n=== GIT STATUS (porcelain) ===\n'; (cd "$W" && git status --porcelain); } > "$OUT/$1.prompt.txt"
  (cd "$S/gradedir" && "${FENCE[@]}" "$APPBIN" -p "$(cat "$OUT/$1.prompt.txt")" ${JUDGE[@]+"${JUDGE[@]}"} --output-format json --max-turns 2 --disallowedTools "$NOTOOLS" > "$OUT/$1.json" 2>/dev/null < /dev/null)
}
downstream down spec.md downstream.md
downstream down2 spec-format.md downstream-ordinary.md
echo "$CASE $ARM $TAG done"
