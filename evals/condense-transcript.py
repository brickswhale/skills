#!/usr/bin/env python3
"""Turn a stream-json run into an ordered, numbered transcript a grader can read.

Keeps every assistant text in full and every tool call's input in full, since
order and the exact prompt handed to bin/dispatch are what the rubric grades.
Tool results are truncated: they are evidence of what came back, not of what
the run decided.
"""
import json
import sys

RESULT_CAP = 1500


def main(path):
    n = 0
    out = []
    for line in open(path):
        try:
            d = json.loads(line)
        except json.JSONDecodeError:
            continue
        t = d.get("type")
        if t == "assistant":
            for b in d["message"].get("content", []):
                if b.get("type") == "text" and b.get("text", "").strip():
                    n += 1
                    out.append(f"[{n}] ASSISTANT TEXT:\n{b['text']}")
                # Text between tool calls can arrive as a thinking block with
                # visible content; dropping it hid a pre-dispatch decision from
                # three graders once. Empty (omitted) thinking carries nothing.
                elif b.get("type") == "thinking" and (b.get("thinking") or "").strip():
                    n += 1
                    out.append(f"[{n}] ASSISTANT PROGRESS NOTE (thinking block, visible text):\n{b['thinking']}")
                elif b.get("type") == "tool_use":
                    n += 1
                    inp = json.dumps(b.get("input"), ensure_ascii=False, indent=1)
                    out.append(f"[{n}] TOOL CALL {b.get('name')}:\n{inp}")
        elif t == "user":
            c = d.get("message", {}).get("content")
            if isinstance(c, list):
                for b in c:
                    if b.get("type") == "tool_result":
                        body = b.get("content")
                        if isinstance(body, list):
                            body = "\n".join(x.get("text", "") for x in body if isinstance(x, dict))
                        body = str(body)
                        if len(body) > RESULT_CAP:
                            body = body[:RESULT_CAP] + f"\n… [{len(body) - RESULT_CAP} more chars]"
                        n += 1
                        out.append(f"[{n}] TOOL RESULT{' (error)' if b.get('is_error') else ''}:\n{body}")
        elif t == "result":
            n += 1
            out.append(f"[{n}] FINAL RESULT (subtype {d.get('subtype')}, turns {d.get('num_turns')}):\n{d.get('result')}")
    print("\n\n".join(out))


if __name__ == "__main__":
    main(sys.argv[1])
