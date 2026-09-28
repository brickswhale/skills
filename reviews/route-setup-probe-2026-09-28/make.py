#!/usr/bin/env python3
"""Build three hand-made setup outputs for the paper probe of the downstream judge.

Each is a correct answer to its own owner requirements, so a sound judge must
pass all three:
  a  Codex builder, Claude reviewer, in the documented formats
  b  no builder has an eligible reviewer, and the policy says the job waits
  c  the same content as (a), in YAML and JSON instead of the documented formats
"""
import os
import subprocess
import sys

ROOT = sys.argv[1]

SPEC = """# spec: refunds

Add `refund(charge_id, amount)` to `app/refunds.py`.

Acceptance:
1. A refund larger than the charge is rejected with `ValueError`.
2. A refund on an unknown charge raises `KeyError`.
3. Refunds follow `docs/refunds.md`.
"""
REFUNDS = """# Refunds

A charge can be refunded in parts. The refunds on one charge never add up to
more than the charge. Every refund is money leaving the account.
"""
STORE = 'charges = {"ch_1": 100}\nrefunds = {}\n'

CONTRACT = """## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder profile and why, the reviewer and why, and every higher-ranked profile you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the registry's value as observed.
- List every review finding you do not act on, with the reason.
"""

ROLES = """## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Frames the job, routes it by this file, integrates the result, and plans; bound by a role's rules whenever it plays that role.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations. Never commits.
- Reviewer: reads the artifact against the spec in a fresh context, never the builder's. Reports supported findings, missing checks and a verdict. Changes nothing. An advisor consult is never the review.
- Reader: gathers cited evidence, keeps what it saw apart from what it infers, decides nothing.
- Partner: answers one blind question through the `pair` skill. Executes nothing and never stands in for a review.
"""


def block(**kv):
    return "\n".join(f"{k}={v}" for k, v in kv.items()) + "\n"


PLUGIN = '"$MACHINE/plugins/codex/1.0.6/scripts/codex-companion.mjs"'

REG_A = "# route-registry\n\n" + "\n".join([
    block(profile="sonnet-build", model="sonnet", family="anthropic", tier="capable", role="builder", card="implementer",
          call="Agent tool, subagent_type=implementer, model=sonnet, one prompt, no continuation", effort="n/a", writes="yes",
          confirmed="no (drafted 2026-09-28)"),
    block(profile="codex-build", model="gpt-6-astra", family="openai", tier="strong", role="builder", card="—",
          call=f'node {PLUGIN} task --fresh --write --model gpt-6-astra --effort medium "<prompt>" < /dev/null', effort="medium",
          writes="yes", confirmed="no (drafted 2026-09-28)"),
    block(profile="fable-review", model="fable", family="anthropic", tier="strong", role="reviewer", card="reviewer",
          call="Agent tool, subagent_type=reviewer, model=fable, one prompt, no continuation", effort="n/a",
          writes="no, enforced (card tools Read, Grep, Glob)", confirmed="no (drafted 2026-09-28)"),
    block(profile="opus-review", model="opus", family="anthropic", tier="strong", role="reviewer", card="reviewer",
          call="Agent tool, subagent_type=reviewer, model=opus, one prompt, no continuation", effort="n/a",
          writes="no, enforced (card tools Read, Grep, Glob)", confirmed="no (drafted 2026-09-28)"),
    block(profile="web-research", model="the owner's web assistant", family="google", tier="capable", role="reader", card="—",
          call="manual: print the ask between copy markers; the owner pastes the reply back", effort="n/a",
          writes="no, enforced (no repository access)", confirmed="2026-09-28 (owner)"),
])

POLICY_A = f"""# Routing policy — refunds

Owner: the owner · Revised: 2026-09-28

## Defaults

- Reviewer: never the author's context; never a lower tier than the builder.
- Same-model fresh review: allowed for ordinary work.
- Money and security: the reviewer is from a different family than the builder.
- Waivers: only the owner, in writing, naming the requirement waived.
- Coordinator does the work itself: never for money-security jobs.
- No `route-registry` on this machine, or a profile this file names is missing from it: stop, and ask the owner to run `/route`. Do not guess a model.
- A profile whose `confirmed` says `no` may be used: the decision line calls it unconfirmed, and its first failed call closes it for the session.

{CONTRACT}
{ROLES}
## Risk classes

- money-security: anything under `app/` that moves money.
- ordinary: everything else.

## Quota

- openai: builds only; never reviews.

## Job: money-feature — a spec that changes money code

Do (ranked):
1. codex-build — every reviewer here is anthropic, so only an openai builder can get a reviewer of another family
2. sonnet-build — only if the owner waives the family rule in writing

Review (alternatives):
1. fable-review — the default
2. opus-review — when fable-review cannot run

## Job: feature — a spec that changes ordinary code

Do (ranked):
1. sonnet-build — the spec pins the work
2. codex-build — the fallback

Review (alternatives):
1. fable-review — the default

## Other obligations

- The web assistant never receives repository code, keys or user data.

## Retired

- none
"""

REG_B = "# route-registry\n\n" + "\n".join([
    block(profile="sonnet-build", model="sonnet", family="anthropic", tier="capable", role="builder", card="implementer",
          call="Agent tool, subagent_type=implementer, model=sonnet, one prompt, no continuation", effort="n/a", writes="yes",
          confirmed="no (drafted 2026-09-28)"),
    block(profile="fable-review", model="fable", family="anthropic", tier="strong", role="reviewer", card="reviewer",
          call="Agent tool, subagent_type=reviewer, model=fable, one prompt, no continuation", effort="n/a",
          writes="no, enforced (card tools Read, Grep, Glob)", confirmed="no (drafted 2026-09-28)"),
    block(profile="web-research", model="the owner's web assistant", family="google", tier="capable", role="reader", card="—",
          call="manual: print the ask between copy markers; the owner pastes the reply back", effort="n/a",
          writes="no, enforced (no repository access)", confirmed="2026-09-28 (owner)"),
])

POLICY_B = POLICY_A.replace(
    """Do (ranked):
1. codex-build — every reviewer here is anthropic, so only an openai builder can get a reviewer of another family
2. sonnet-build — only if the owner waives the family rule in writing

Review (alternatives):
1. fable-review — the default
2. opus-review — when fable-review cannot run""",
    """Do (ranked):
1. owner — no builder on this machine can get a reviewer of another family (every builder and reviewer here is anthropic); the job waits for the owner's ruling
2. sonnet-build — only after the owner waives the family rule in writing

Review (alternatives):
1. fable-review — the default""").replace(
    """Do (ranked):
1. sonnet-build — the spec pins the work
2. codex-build — the fallback""",
    """Do (ranked):
1. sonnet-build — the spec pins the work""").replace("- openai: builds only; never reviews.", "- none: no metered family on this machine.")

POLICY_C = """# routing policy for the refunds service (YAML)
owner: the owner
revised: 2026-09-28
defaults:
  reviewer: never the author's context; never a lower tier than the builder
  money_and_security: reviewer family must differ from builder family
  waivers: owner only, in writing
  coordinator_does_money_work: never
  missing_model: stop and ask the owner to run /route
  unconfirmed_profile: may be used; the decision line calls it unconfirmed, and its first failed call closes it for the session
contract:
  - before the first dispatch, print one decision line with the job, your own model, builder and why, reviewer and why, and each higher-ranked profile skipped with its reason
  - the reviewer's prompt carries spec, code or diff, and test output; never the builder's verdict or your judgement
  - after review, print a receipt of the model each role reported, or unknown; never the registry value as observed
  - list every finding not acted on, with the reason
risk_classes:
  money-security: anything under app/ that moves money
  ordinary: everything else
quota:
  openai: builds only, never reviews
jobs:
  money-feature:
    do:
      - {profile: codex-build, when: "every reviewer is anthropic, so only an openai builder gets a reviewer of another family"}
      - {profile: sonnet-build, when: "only if the owner waives the family rule in writing"}
    review: {mode: alternatives, list: [fable-review, opus-review]}
  feature:
    do:
      - {profile: sonnet-build, when: "the spec pins the work"}
      - {profile: codex-build, when: "fallback"}
    review: {mode: alternatives, list: [fable-review]}
other:
  - the web assistant never receives repository code, keys or user data
"""

REG_C = """{
  "machine": "this machine",
  "profiles": {
    "sonnet-build": {"model": "sonnet", "family": "anthropic", "tier": "capable", "role": "builder", "writes": true, "call": "Agent tool, subagent_type=implementer, model=sonnet", "confirmed": "no (drafted 2026-09-28)"},
    "codex-build": {"model": "gpt-6-astra", "family": "openai", "tier": "strong", "role": "builder", "writes": true, "call": "node $MACHINE/plugins/codex/1.0.6/scripts/codex-companion.mjs task --fresh --write --model gpt-6-astra --effort medium \\"<prompt>\\" < /dev/null", "confirmed": "no (drafted 2026-09-28)"},
    "fable-review": {"model": "fable", "family": "anthropic", "tier": "strong", "role": "reviewer", "writes": false, "call": "Agent tool, subagent_type=reviewer, model=fable", "confirmed": "no (drafted 2026-09-28)"},
    "opus-review": {"model": "opus", "family": "anthropic", "tier": "strong", "role": "reviewer", "writes": false, "call": "Agent tool, subagent_type=reviewer, model=opus", "confirmed": "no (drafted 2026-09-28)"},
    "web-research": {"model": "the owner's web assistant", "family": "google", "tier": "capable", "role": "reader", "writes": false, "call": "manual: the owner pastes the ask and the reply", "confirmed": "2026-09-28 (owner)"}
  }
}
"""

CASES = {
    "a": ("docs/routing.md", POLICY_A, ".machine/route-registry", REG_A),
    "b": ("docs/routing.md", POLICY_B, ".machine/route-registry", REG_B),
    "c": ("docs/routing.yaml", POLICY_C, ".machine/models.json", REG_C),
}

for name, (pol_path, pol, reg_path, reg) in CASES.items():
    d = os.path.join(ROOT, name)
    os.makedirs(d, exist_ok=True)
    files = {
        "AGENTS.md": f"# refunds — agent briefing\n\nRouting: `{pol_path}`. This machine's models: `{reg_path}`.\n",
        "docs/spec.md": SPEC,
        "docs/refunds.md": REFUNDS,
        "app/__init__.py": "",
        "app/store.py": STORE,
        pol_path: pol,
        reg_path: reg,
    }
    for rel, body in files.items():
        p = os.path.join(d, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w") as fh:
            fh.write(body)
    subprocess.run("git init -q -b main . && git config user.email t@t && git config user.name t && git add -A && git commit -qm probe",
                   shell=True, cwd=d, check=True)
    print(name, "built:", pol_path, reg_path)
