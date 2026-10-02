#!/usr/bin/env python3
"""Generate evals/route-update/scaffold.sh and evals/route-setup/scaffold.sh.

Each scaffold is self-contained (the eval runner copies it alone into an empty
directory), so the route references are embedded as they stand when this runs.
Re-run it whenever skills/route/references/ or the pair catalog changes.
"""
import os
import sys

REPO = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REF = os.path.join(REPO, "skills/route/references")
KIT = {
    "template.md": open(os.path.join(REF, "template.md")).read(),
    "rules.md": open(os.path.join(REF, "rules.md")).read(),
}
for name, body in KIT.items():
    assert "KITEOF" not in body, name


def heredoc(path, body, tag="KITEOF"):
    return f"cat > {path} <<'{tag}'\n{body.rstrip()}\n{tag}\n"


PLUGIN_JS = r"""#!/usr/bin/env node
// Stub of the Codex plugin's companion script. Logs every call, and rejects
// what the real plugin rejects: an effort outside none..xhigh, and a model the
// machine's Codex cache does not list as visible.
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
const here = path.dirname(fileURLToPath(import.meta.url));
const machine = path.resolve(here, "../../../..");
const log = path.join(machine, "plugin-calls.log");
const args = process.argv.slice(2);
fs.appendFileSync(log, JSON.stringify(args) + "\n");
const commands = new Set(["setup", "review", "adversarial-review", "task", "status", "result", "cancel"]);
if (!commands.has(args[0])) { console.error("usage: codex-companion.mjs <setup|review|adversarial-review|task|status|result|cancel> ..."); process.exit(2); }
const valued = new Set(["--effort", "--model", "--cwd", "--prompt-file"]);
const rest = args.slice(1).filter((a, k, all) => !a.startsWith("--") && !valued.has(all[k - 1]));
if (args[0] === "task" && rest.length === 0) { console.error("task: no prompt given"); process.exit(2); }
const ok = new Set(["none", "minimal", "low", "medium", "high", "xhigh"]);
const i = args.indexOf("--effort");
if (i >= 0 && !ok.has(args[i + 1])) {
  console.error(`Unsupported reasoning effort "${args[i + 1]}". Use one of: none, minimal, low, medium, high, xhigh.`);
  process.exit(2);
}
const cache = JSON.parse(fs.readFileSync(path.join(machine, "codex/models_cache.json"), "utf8"));
const visible = new Set(cache.models.filter(m => m.visibility === "list").map(m => m.slug));
const j = args.indexOf("--model");
if (j >= 0 && !visible.has(args[j + 1])) {
  console.error(`Unknown model "${args[j + 1]}".`);
  process.exit(2);
}
console.log("ok (stub: nothing was sent)");
"""


def cache(client, models):
    import json
    levels = lambda top: [{"effort": e} for e in ["low", "medium", "high", "xhigh", "max", "ultra"][: top]]
    return json.dumps({
        "fetched_at": "2026-09-27T09:00:00Z",
        "client_version": client,
        "models": [{"slug": s, "display_name": s, "visibility": v, "priority": p, "supported_reasoning_levels": levels(n)}
                   for s, v, p, n in models],
    }, indent=1)


def machine_block(plugin_ver, client, models, pair_plugin_ver, pair_client):
    return f"""mkdir -p .machine/codex .machine/plugins/codex/{plugin_ver}/scripts bin
ROOT=$(pwd)
printf 'model = "gpt-6-astra"\\nmodel_reasoning_effort = "low"\\n' > .machine/codex/config.toml
{heredoc(".machine/codex/models_cache.json", cache(client, models), "JSONEOF")}
cat > .machine/plugins.json <<JSONEOF
[{{"id": "codex@openai-codex", "version": "{plugin_ver}", "enabled": true, "scope": "user", "installPath": "$ROOT/.machine/plugins/codex/{plugin_ver}"}}]
JSONEOF
{heredoc(f".machine/plugins/codex/{plugin_ver}/scripts/codex-companion.mjs", PLUGIN_JS, "JSEOF")}
mkdir -p .machine/pair
cat > .machine/pair/pair-transport.anthropic <<RECEOF
# pair transport record — host family: anthropic
partner=codex-plugin
family=openai-gpt
rung=1
call=node "$ROOT/.machine/plugins/codex/{pair_plugin_ver}/scripts/codex-companion.mjs" task --fresh --effort medium "<prompt>" < /dev/null
readonly=enforced (Codex read-only sandbox; never --write)
confirmed=2026-09-23 (codex-cli {pair_client}, plugin {pair_plugin_ver})
RECEOF
cat > bin/codex <<'SHEOF'
#!/usr/bin/env bash
# Stub Codex CLI: answers --version only; anything else is logged and refused.
here=$(cd "$(dirname "$0")/.." && pwd)
printf '%s\\n' "$*" >> "$here/.machine/codex-cli-calls.log"
[ "${{1:-}}" = "--version" ] && {{ echo "codex-cli {client}"; exit 0; }}
echo "codex (stub): only --version is available here" >&2; exit 2
SHEOF
cat > bin/claude <<'SHEOF'
#!/usr/bin/env bash
# Stub Claude Code CLI: answers --version and `plugin list --json` from .machine/; refuses the rest.
here=$(cd "$(dirname "$0")/.." && pwd)
printf '%s\n' "$*" >> "$here/.machine/claude-cli-calls.log"
case "$*" in
  --version) echo "2.1.247 (Claude Code)"; exit 0 ;;
  "plugin list --json"|"plugin list --json "*) cat "$here/.machine/plugins.json"; exit 0 ;;
esac
echo "claude (stub): only --version and plugin list --json are available here" >&2; exit 2
SHEOF
mkdir -p .machine/claude/agents
cat > .machine/claude/agents/implementer.md <<'MD'
---
name: implementer
description: Builds exactly what a bounded spec asks for, runs its checks, reports; never commits.
---
You build what the spec names and nothing else. Run the named checks and quote their output. Never commit, stage or push.
MD
cat > .machine/claude/agents/reviewer.md <<'MD'
---
name: reviewer
description: Reviews an artifact against its spec in a fresh context; read-only.
tools: Read, Grep, Glob
---
You review the named artifact against its spec. Report supported findings, missing checks and a verdict. You change nothing.
MD
chmod +x bin/codex bin/claude .machine/plugins/codex/{plugin_ver}/scripts/codex-companion.mjs
"""


def kit_block():
    out = "mkdir -p routing-kit\n"
    for name, body in KIT.items():
        out += heredoc(f"routing-kit/{name}", body)
    # the skill as installed on this stand-in machine: policies name its rules
    # under ~/.claude/skills/route/, and .machine/ stands in for ~/.claude
    out += "mkdir -p .machine/claude/skills/route/references\n"
    out += heredoc(".machine/claude/skills/route/references/rules.md", KIT["rules.md"])
    return out


def project(dirname, agents_extra=""):
    return f"""mkdir -p {dirname}/app {dirname}/docs {dirname}/tests
cat > {dirname}/AGENTS.md <<'MD'
# {os.path.basename(dirname)} — agent briefing

Commands:
- test: `python3 -m unittest discover -s tests -q`
{agents_extra}
Never commit. The owner commits.
MD
cat > {dirname}/docs/spec.md <<'MD'
# spec: refunds

Add `refund(charge_id, amount)` to `app/refunds.py`.

Acceptance:
1. A refund larger than the charge is rejected with `ValueError`.
2. A refund on an unknown charge raises `KeyError`.
3. Refunds follow `docs/refunds.md`.
MD
cat > {dirname}/docs/spec-format.md <<'MD'
# spec: amount formatting

Add `format_amount(cents)` to `tools/format.py`: it returns the amount as a
string with two decimals, such as `format_amount(1050) == "10.50"`.

Acceptance:
1. `format_amount(1050)` returns `"10.50"`; `format_amount(5)` returns `"0.05"`.
2. A test in `tests/test_format.py` covers both.
3. Nothing under `app/` changes.
MD
cat > {dirname}/docs/refunds.md <<'MD'
# Refunds

A charge can be refunded in parts. The refunds on one charge never add up to
more than the charge. Every refund is money leaving the account.
MD
: > {dirname}/app/__init__.py
printf 'charges = {{"ch_1": 100}}\\nrefunds = {{}}\\n' > {dirname}/app/store.py
: > {dirname}/tests/__init__.py
"""


ROOT_AGENTS = """cat > AGENTS.md <<'MD'
# this machine — agent briefing

This directory stands in for one owner's machine.

- `.machine/` is the machine's config directory: Codex config and model cache in `codex/`, Claude Code's agent cards in `claude/agents/`, the plugin list, and the pair skill's record. It stands in for every config location a tool would use on a real machine (`~/.config/…`, `~/.codex`, `~/.claude`): anything that would live there lives in `.machine/`. Treat only what it lists as installed, and look nowhere outside this directory.
- `bin/` holds the command-line tools installed here (`codex`, `claude`); it is first on PATH.
- `routing-kit/` holds copies of the model-routing references: the route template and the routing rules.
- `projects/` holds the owner's projects on this machine.
MD
"""

HEAD = """#!/usr/bin/env bash
# GENERATED by a build script from skills/route/references/ and the pair
# catalog as they stood when it ran; regenerate after either changes.
"""

# ---------------------------------------------------------------- route-update
UPDATE_REG = """mkdir -p .machine/route
cat > .machine/route/dictionary.md <<REGEOF
# Model dictionary — this machine

Owner: the owner · Revised: 2026-09-26 · Tools seen: claude 2.1.247, codex-cli 0.154.0, plugin codex 1.0.6

## Sonnet

- Model: sonnet
- Family: anthropic · Tier: capable
- Good for: builds from a clear spec
- Cost: Claude plan
- Build call: Agent tool, subagent_type=implementer, model=sonnet, one prompt, no continuation · writes: yes
- Effort: n/a
- Confirmed: 2026-09-26 (claude 2.1.247)

## Fable

- Model: fable
- Family: anthropic · Tier: strong
- Good for: reviews, diagnosis
- Cost: Claude plan
- Review call: Agent tool, subagent_type=reviewer, model=fable, one prompt, no continuation · writes: no, enforced (card tools Read, Grep, Glob)
- Effort: n/a
- Confirmed: 2026-09-26 (claude 2.1.247)

## Opus

- Model: opus
- Family: anthropic · Tier: strong
- Good for: reviews when Fable cannot run
- Cost: Claude plan
- Review call: Agent tool, subagent_type=reviewer, model=opus, one prompt, no continuation · writes: no, enforced (card tools Read, Grep, Glob)
- Effort: n/a
- Confirmed: 2026-09-26 (claude 2.1.247)

## Terra

- Model: gpt-5.6-terra
- Family: openai · Tier: capable
- Good for: ordinary builds
- Cost: Codex plan
- Build call: node "$ROOT/.machine/plugins/codex/1.0.6/scripts/codex-companion.mjs" task --fresh --write --model gpt-5.6-terra --effort medium "<prompt>" < /dev/null · writes: yes
- Effort: medium
- Confirmed: 2026-09-26 (codex-cli 0.154.0, plugin 1.0.6)

## Astra

- Model: gpt-6-astra
- Family: openai · Tier: strong
- Good for: audits from another family
- Cost: Codex plan
- Review call: node "$ROOT/.machine/plugins/codex/1.0.6/scripts/codex-companion.mjs" task --fresh --model gpt-6-astra --effort high "<prompt>" < /dev/null · writes: no, enforced (Codex read-only sandbox)
- Effort: high
- Confirmed: 2026-09-26 (codex-cli 0.154.0, plugin 1.0.6)

## Gemini web app

- Model: the owner's Gemini web app
- Family: google · Tier: capable
- Good for: broad web research
- Cost: the owner's Gemini plan
- Review call: manual: print the ask between copy markers; the owner pastes the reply back · writes: no, enforced (no repository access)
- Effort: n/a
- Confirmed: 2026-09-26 (owner)
REGEOF
"""

# The update fixture's routing as the owner left it on 2026-09-26: one shared
# policy beside the registry, a pointer line in each project's briefing, and
# ledger's own routing lines under its pointer (they win in ledger). Frozen
# here on purpose; never regenerate this block from the current template.
SHARED_POLICY = """# Jobs — this machine

Owner: the owner · Revised: 2026-09-26

| Job | Builders (ranked) | Reviewers (ranked) | Notes |
|---|---|---|---|
| Small fix — cause known, no design choice, a few files | main session | main session reads its own diff; the failing check now passes | |
| Build — a feature or change from a clear spec | Sonnet (the spec pins the work) → Terra (the fallback) | Fable → Opus (when Fable cannot run) | |
| Money-security build — code that moves money | Terra (every reviewer allowed here is anthropic, so only an openai builder can get a reviewer of another family) → Sonnet (only if the owner waives the family rule in writing) | Fable → Opus (when Fable cannot run) | a project names its own paths under its pointer |
| Research — facts from outside the repository | main session's own tools → Gemini web app (broad research) | main session checks every cited fact | the Gemini web app never receives repository code |

## Notes

- Quota: openai: builds only; never reviews.
- Every build is followed by the project's test command, and its result goes to the reviewer.
- The owner reads a money job's spec before it is dispatched.
- Retired: 2026-09-10 — a second model pre-checks every spec before dispatch — too costly for small specs; the owner
"""

POINTER = "Routing: before handing work off, read the `route` skill's rules (`~/.claude/skills/route/references/rules.md`; Codex: `~/.agents/skills/route/references/rules.md`). If they or the files they name are missing, say so and ask the owner to run `/route`; never guess a model.\n"

REFUNDS_LINES = "\n" + POINTER + "Routing in this project: money-security here is anything under `app/` that moves money.\n"

LEDGER_LINES = "\n" + POINTER + """Routing in this project (the owner's, 2026-09-26):
- money-security here: anything under `app/` that moves money.
- openai: audits and builds; never docs.
- Money-security build: Sonnet builds, the spec pins the work; reviewers cumulative: Fable, then Astra, the different-family audit money work needs, never before the Claude review.
- Build: reviewer Opus.
- Effort floor: no Codex call runs below high.
"""

UPDATE = HEAD + """# route-update: a machine whose Codex changed under an existing routing setup.
#
# The registry was written on 2026-09-26 and serves two projects. Since then the
# Codex plugin moved from 1.0.6 to 1.0.7 (the 1.0.6 directory is gone), the
# Codex client moved from 0.154.0 to 0.158.0, gpt-5.6-terra left the model
# cache, and gpt-6-sol appeared. A good update re-points what moved without
# calling it confirmed, keeps the gone model's profile marked and lists every rank
# that names it, in the shared policy and in a project's own routing lines,
# instead of choosing a replacement, reports the visible model that has no
# profile without ranking it, flags the stale confirmations, never proposes a
# hidden model, and leaves the owner-written obligations, the Retired section,
# ledger's own routing lines and the pair record untouched.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
""" + machine_block("1.0.7", "0.158.0", [
    ("gpt-6-astra", "list", 1, 6), ("gpt-6-sol", "list", 2, 6), ("gpt-6-luna", "list", 3, 5),
    ("gpt-reserve", "hide", 3, 5), ("gpt-5.6-luna", "list", 8, 5), ("codex-auto-review", "hide", 43, 5)],
    pair_plugin_ver="1.0.6", pair_client="0.154.0") + UPDATE_REG + kit_block() + ROOT_AGENTS + \
    heredoc(".machine/route/jobs.md", SHARED_POLICY, "POLEOF") + \
    project("projects/refunds", REFUNDS_LINES) + \
    project("projects/ledger", LEDGER_LINES) + \
    """printf '*.log\\n__pycache__/\\n' > .gitignore
git add -A -- . ":!scaffold.sh" && git commit -qm "machine and projects as routed on 2026-09-26"
"""

# ---------------------------------------------------------------- route-setup
SETUP = HEAD + """# route-setup: a machine with no routing yet, and one project.
#
# The owner's answers are in the prompt. Every reviewer the owner allows is a
# Claude model (Codex is for builds only, the Gemini web app never sees code),
# so a Claude builder cannot be reviewed by another family on a money job: a
# good setup ranks the Codex builder first for money work, or flags it. The
# pair record points at a plugin version that is no longer installed, so it is
# stale and must be reported, not rewritten. Two cache models are hidden; the
# cache lists efforts the plugin rejects.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
""" + machine_block("1.0.7", "0.158.0", [
    ("gpt-6-astra", "list", 1, 6), ("gpt-6-sol", "list", 2, 6), ("gpt-6-luna", "list", 3, 5),
    ("gpt-reserve", "hide", 3, 5), ("codex-auto-review", "hide", 43, 5)],
    pair_plugin_ver="1.0.6", pair_client="0.154.0") + kit_block() + ROOT_AGENTS + \
    project("projects/refunds") + \
    """printf '*.log\\n__pycache__/\\n' > .gitignore
git add -A -- . ":!scaffold.sh" && git commit -qm "machine and project before routing"
"""

for case, body in (("route-update", UPDATE), ("route-setup", SETUP)):
    d = os.path.join(REPO, "evals", case)
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, "scaffold.sh")
    with open(p, "w") as fh:
        fh.write(body)
    os.chmod(p, 0o755)
    print("wrote", p, len(body), "bytes")
