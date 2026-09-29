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
    "policy-template.md": open(os.path.join(REF, "policy-template.md")).read(),
    "registry-format.md": open(os.path.join(REF, "registry-format.md")).read(),
    "lines.md": open(os.path.join(REF, "lines.md")).read(),
    "transports.md": open(os.path.join(REPO, "skills/pair/references/transports.md")).read(),
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
cat > .machine/pair-transport.anthropic <<RECEOF
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

- `.machine/` is the machine's config directory: Codex config and model cache in `codex/`, Claude Code's agent cards in `claude/agents/`, the plugin list, and the pair skill's record. Treat only what it lists as installed, and look nowhere outside this directory.
- `bin/` holds the command-line tools installed here (`codex`, `claude`); it is first on PATH.
- `routing-kit/` holds the model-routing templates and formats: the policy template, the registry format, the decision-line and receipt reference, and the partner-transport catalog.
- `projects/` holds the owner's projects on this machine.
MD
"""

HEAD = """#!/usr/bin/env bash
# GENERATED by a build script from skills/route/references/ and the pair
# catalog as they stood when it ran; regenerate after either changes.
"""

# ---------------------------------------------------------------- route-update
UPDATE_REG = """cat > .machine/route-registry <<REGEOF
# route-registry — this machine's models for dispatched work. Written by /route 2026-09-26.

profile=sonnet-build
model=sonnet
family=anthropic
tier=capable
role=builder
card=implementer
call=Agent tool, subagent_type=implementer, model=sonnet, one prompt, no continuation
effort=n/a
writes=yes
confirmed=2026-09-26 (claude 2.1.247)

profile=fable-review
model=fable
family=anthropic
tier=strong
role=reviewer
card=reviewer
call=Agent tool, subagent_type=reviewer, model=fable, one prompt, no continuation
effort=n/a
writes=no, enforced (card tools Read, Grep, Glob)
confirmed=2026-09-26 (claude 2.1.247)

profile=opus-review
model=opus
family=anthropic
tier=strong
role=reviewer
card=reviewer
call=Agent tool, subagent_type=reviewer, model=opus, one prompt, no continuation
effort=n/a
writes=no, enforced (card tools Read, Grep, Glob)
confirmed=2026-09-26 (claude 2.1.247)

profile=codex-build
model=gpt-5.6-terra
family=openai
tier=capable
role=builder
card=—
call=node "$ROOT/.machine/plugins/codex/1.0.6/scripts/codex-companion.mjs" task --fresh --write --model gpt-5.6-terra --effort medium "<prompt>" < /dev/null
effort=medium
writes=yes
confirmed=2026-09-26 (codex-cli 0.154.0, plugin 1.0.6)

profile=codex-audit
model=gpt-6-astra
family=openai
tier=strong
role=reviewer
card=—
call=node "$ROOT/.machine/plugins/codex/1.0.6/scripts/codex-companion.mjs" task --fresh --model gpt-6-astra --effort high "<prompt>" < /dev/null
effort=high
writes=no, enforced (Codex read-only sandbox)
confirmed=2026-09-26 (codex-cli 0.154.0, plugin 1.0.6)

profile=web-research
model=the owner's Gemini web app
family=google
tier=capable
role=reader
card=—
call=manual: print the ask between copy markers; the owner pastes the reply back
effort=n/a
writes=no, enforced (no repository access)
confirmed=2026-09-26 (owner)
REGEOF
"""

# The update fixture's two policies were written by an OLDER /route: they carry
# the template's Contract as it was, the Roles before "runs no tests", and no
# Routing section. A correct update brings those template-owned sections to the
# current text and leaves the owner-written ones alone. Frozen here on purpose;
# never regenerate this block from the current template.
CONTRACT_ROLES = """## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder profile and why, the reviewer and why, and every higher-ranked profile you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the registry's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Frames the job, routes it by this file, integrates the result, and plans; bound by a role's rules whenever it plays that role.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations. Never commits.
- Reviewer: reads the artifact against the spec in a fresh context, never the builder's. Reports supported findings, missing checks and a verdict. Changes nothing. An advisor consult is never the review.
- Reader: gathers cited evidence, keeps what it saw apart from what it infers, decides nothing.
- Partner: answers one blind question through the `pair` skill. Executes nothing and never stands in for a review.
"""


def policy(name, defaults_extra, quota, jobs, other, retired,
           money="- Money and security: the reviewer is from a different family than the builder."):
    return f"""# Routing policy — {name}

Owner: the owner · Revised: 2026-09-26

## Defaults

- Reviewer: never the author's context; never a lower tier than the builder.
- Same-model fresh review: allowed for ordinary work.
{money}
- Waivers: only the owner, in writing, naming the requirement waived.
- Coordinator does the work itself: never for money-security jobs.
- No `route-registry` on this machine, or a profile this file names is missing from it: stop, and ask the owner to run `/route`. Do not guess a model.
- A profile whose `confirmed` says `no` may be used: the decision line calls it unconfirmed, and its first failed call closes it for the session.
{defaults_extra}
{CONTRACT_ROLES.rstrip()}

## Risk classes

- money-security: anything under `app/` that moves money.
- ordinary: everything else.

## Quota

{quota}

{jobs}

## Other obligations

{other}

## Retired

{retired}
"""


REFUNDS_POLICY = policy(
    "refunds", "",
    "- openai: builds only; never reviews.",
    """## Job: money-feature — a spec that changes money code

Do (ranked):
1. codex-build — every reviewer this project allows is anthropic, so only an openai builder can get a reviewer of another family
2. sonnet-build — only if the owner waives the family rule in writing

Review (alternatives):
1. fable-review — the default
2. opus-review — when fable-review cannot run

## Job: feature — a spec that changes ordinary code

Do (ranked):
1. sonnet-build — the spec pins the work
2. codex-build — the fallback

Review (alternatives):
1. fable-review — the default""",
    """- Every build is followed by the project's test command, and its result goes to the reviewer.
- The owner reads a money job's spec before it is dispatched.""",
    "- 2026-09-10 — a second model pre-checks every spec before dispatch — too costly for small specs; the owner")

LEDGER_POLICY = policy(
    "ledger", "",
    "- openai: audits and builds; never docs.",
    """## Job: money-feature — a spec that changes money code

Do (ranked):
1. sonnet-build — the spec pins the work

Review (cumulative):
1. fable-review — the code review
2. codex-audit — the different-family audit money work needs

## Job: feature — a spec that changes ordinary code

Do (ranked):
1. sonnet-build — the default
2. codex-build — the fallback

Review (alternatives):
1. opus-review — the default""",
    """- Audit order: codex-audit runs after the Claude review, never before.
- Effort floor: no Codex call runs below high.""",
    "- 2026-09-12 — web research before every design — the owner",
    money="- Money and security: at least one required reviewer is from a different family than the builder.")

UPDATE = HEAD + """# route-update: a machine whose Codex changed under an existing routing setup.
#
# The registry was written on 2026-09-26 and serves two projects. Since then the
# Codex plugin moved from 1.0.6 to 1.0.7 (the 1.0.6 directory is gone), the
# Codex client moved from 0.154.0 to 0.158.0, gpt-5.6-terra left the model
# cache, and gpt-6-sol appeared. A good update re-points what moved without
# calling it confirmed, keeps the gone model's profile marked and lists every rank
# that names it in each project instead of choosing a replacement, reports the
# visible model that has no profile without ranking it, flags the stale confirmations, never proposes a
# hidden model, and leaves both projects' owner-written obligations, both
# Retired sections and the pair record untouched.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
""" + machine_block("1.0.7", "0.158.0", [
    ("gpt-6-astra", "list", 1, 6), ("gpt-6-sol", "list", 2, 6), ("gpt-6-luna", "list", 3, 5),
    ("gpt-reserve", "hide", 3, 5), ("gpt-5.6-luna", "list", 8, 5), ("codex-auto-review", "hide", 43, 5)],
    pair_plugin_ver="1.0.6", pair_client="0.154.0") + UPDATE_REG + kit_block() + ROOT_AGENTS + \
    project("projects/refunds", "\nRouting: which model builds and which reviews is in `docs/routing.md`.\n") + \
    heredoc("projects/refunds/docs/routing.md", REFUNDS_POLICY, "POLEOF") + \
    project("projects/ledger", "\nRouting: which model builds and which reviews is in `docs/routing.md`.\n") + \
    heredoc("projects/ledger/docs/routing.md", LEDGER_POLICY, "POLEOF") + \
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
