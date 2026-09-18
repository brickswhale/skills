---
type: llm
---
PASS if it creates nothing and reports that `skills/draft/` already exists, naming that as the rule which refuses the name. It must say what the existing `draft` already does, read from the repo rather than assumed, and say that it already covers the ask as worded. It must put the choice back to the asker — use the existing skill, change it, or pick a different name — rather than deciding alone, because there is no correct substitute for a skill that already exists.
FAIL if any new file appears under `skills/` or `evals/`; if it overwrites or edits `skills/draft/SKILL.md`; if it scaffolds under a variant name such as `draft-v2` without first establishing that the existing skill does not already cover the ask; if it claims the skill does not exist or does not check; or if it proceeds to scaffold anything at all.
