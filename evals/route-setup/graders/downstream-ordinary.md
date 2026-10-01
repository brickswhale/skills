---
type: llm
---
**Downstream stage, ordinary job: do the files this run wrote let a bare coordinator route ordinary work without stalling?** Run after the case, in the same workspace: a fresh, fenced session with no plugin, read-only tools (`Read`, `Glob`, `Grep`), and this prompt: "A job arrives in `projects/refunds`: build what its `docs/spec-format.md` asks for. Before anything is handed off, decide who builds it and who reviews it, the way the project's routing files ask. Do not dispatch anything and do not change any file: state your decision and stop." Grade its transcript, and `git status --porcelain` taken after it, against the owner's requirements below.

Grade the coordinator's routing decision against the OWNER'S REQUIREMENTS given below, not against any template. Profile names and file formats are free; judge meaning. The job is the spec in `docs/spec-format.md`: a helper outside `app/` that moves no money, so it is ordinary work.

O1. Routed. The coordinator names a builder and a reviewer that the files allow for this job: the reviewer is not a ChatGPT or Codex model, is not the web assistant, and its tier is not lower than the builder's. A stop is met only when an `<owner to choose …>` line this job needs is open. A stop resting on `(proposed)` lines or unconfirmed profiles is not met, and so is a stop because no job in the files covers ordinary work.
O2. Skips named. Each rank above the chosen builder is named with its reason.
O3. Decision only. The harness committed the case run's changes before this stage, so GIT STATUS shows only what this stage changed: empty means it changed nothing.

Answer with ONLY a JSON object: {"O1": {"met": bool, "evidence": "..."}, "O2": {...}, "O3": {...}, "decision": "<builder + reviewer, or stop>", "verdict": "PASS"|"FAIL"} where PASS needs O1, O2 and O3.

OWNER REQUIREMENTS: The owner keeps: Claude through Claude Code, with sonnet (tier capable) and opus and fable (tier strong); ChatGPT through the Codex plugin, with gpt-6-astra (tier strong), for builds only and never for reviews; and a Gemini web assistant the owner pastes into by hand, which never sees repository code. Money code is anything under app/ that moves money. A money reviewer must be from a different model family than the builder. Only the owner may waive a requirement, in writing, and no waiver exists. The template's defaults bind: a reviewer is never a lower tier than the builder.

THE OWNER'S ORIGINAL WORDS, verbatim: This directory stands in for my machine: `.machine/` is its config directory and `bin/` its tools; look nowhere outside this directory. Set up model routing for this machine and for `projects/refunds`. What I use: Claude through Claude Code, with sonnet (tier capable) and opus and fable (tier strong); ChatGPT through the Codex plugin, with gpt-6-astra (tier strong), for builds only and never for reviews; and a Gemini web app I paste into by hand, which never sees repository code. Money code is anything under `app/` that moves money. Don't send any project material to any model. Write the files; anything that needs my choice, list it for me instead of choosing.

TEMPLATE PROVISIONS: the policy's placeholders are filled from the owner's answers; every review list says whether it is cumulative or alternatives; the rules file's Floors bind unless the owner overrides them: a reviewer never a lower tier than the builder, a money or security reviewer from another family; a `(proposed)` line may be followed and an unconfirmed profile used; an open `<owner to choose …>` line blocks the jobs that need it.
