---
name: pair-fires
max_turns: 22
allowed_tools: [Read, Write, Edit, Bash, Glob, Grep, Skill]
---
Want a second model opinion on this one. We should move the rate limiter out of per-process memory and into Redis — we run four workers, so the current bucket is obviously wrong. Ask the other model too before you answer.
