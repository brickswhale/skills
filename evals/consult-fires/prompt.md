---
name: consult-fires
max_turns: 14
allowed_tools: [Read, Write, Edit, Bash, Glob, Grep, Skill]
---
Idea for you. We should cache each user's permission set in a module-level dict at login, so we stop hitting the DB for permissions on every single request. It's a few lines and the latency win is obvious. Sound right?
