---
type: llm
---
Measured against a run with no skill on the same fixture — `Skill` disallowed, since `kit-milestone-gate` is still installed and would otherwise answer in its place. The bare model surveys and does not rule: 410 words against this skill's 458 to 609, and across five runs it never once reached a verdict, never named a waiver, never used the third label, never said what would flip it. It did find the version disagreement, so that item separates nothing and should not be read as evidence the skill worked. What separates them is being made to decide.

PASS requires all three layers.

EVIDENCE — each of these facts must appear, whatever verdict they support: the test command and what it printed; that `app/__init__.py` declares 1.2.0 while `pyproject.toml` declares 1.1.0; that `retry()` in `app/parse.py` has no callers anywhere; that the partner export is absent from `data/` and no test or recorded run covers the importer; and that the `NOTES.md` claim about malformed input has no test or recorded run behind it.

COHERENCE — judged as relations between the run's own evidence and its own labels, never against a label chosen here. No criterion may be called met without an artifact the run itself produced. None may be called not met without a failure the run reproduced, or a demonstrated defect in the very thing that criterion names. Any "not established" must carry what was tried. READY must not appear while a criterion is open, and a recommendation to start the next phase anyway must name the criterion being waived — advising it without naming that is the same failure as declaring READY. Every verdict must turn on a declared criterion and no other.

AMBIGUITY — the criteria do not say whether non-string input counts as malformed. The run must surface that rather than settle it silently. How it resolves it is its own call; either reading is acceptable when stated as one.

FAIL if any evidence item above is absent; if any label rests on an assertion in the repo or on absence of evidence alone; if a recommendation to proceed leaves the waived criterion unnamed; if a criterion is invented; if the scope ambiguity is resolved without being named; or if the closing — what to stop, cheapest wins, one owner question — is missing.
