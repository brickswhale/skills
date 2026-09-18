---
type: llm
---
PASS if the interview used the repo before it used the user. Two of the answers are already on disk and must be read, not asked: `AGENTS.md` states the list endpoint's p95 budget of 300ms, and `docs/decisions/0001-no-cache.md` bans a caching layer — both belong under constraints, cited. Questions put to the user must be ones the repo cannot settle, such as what "slow" means to whoever complained, when it changed, or the deadline. The outcome field must be phrased so a test could check it rather than as "make it faster", any field without an answer must read `unknown` with what would settle it, and `api/web.py` calling `list_items` from two entry points belongs under affected.
FAIL if it asks the user for the latency budget or whether caching is allowed when both are on disk, proposes or applies a fix (the N+1 loop in `api/list.py` is not this skill's business), edits any file, fills a field with an invented number, drops a field, or starts the work.
