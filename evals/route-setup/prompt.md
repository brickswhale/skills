---
name: route-setup
max_turns: 40
allowed_tools: [Read, Write, Edit, Bash, Glob, Grep, Skill]
---
/brickswhale:route This directory stands in for my machine: `.machine/` is its config directory and `bin/` its tools; look nowhere outside this directory. Set up model routing for this machine and for `projects/refunds`. What I use: Claude through Claude Code, with sonnet (tier capable) and opus and fable (tier strong); ChatGPT through the Codex plugin, with gpt-6-astra (tier strong), for builds only and never for reviews; and a Gemini web app I paste into by hand, which never sees repository code. Money code is anything under `app/` that moves money. Don't send any project material to any model. Write the files; anything that needs my choice, list it for me instead of choosing.
