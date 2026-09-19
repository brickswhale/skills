#!/usr/bin/env bash
# A genuine two-sided decision, plus a reachable partner that disagrees.
#
# The trade is real: four workers make a per-process bucket wrong, but the
# service runs no Redis and documents a hard latency budget. Both answers are
# defensible, so the synthesis has something to preserve rather than average.
#
# bin/partner is a stub with a FIXED answer: it logs the prompt it was handed
# and argues the other side. Two things are then observable in the transcript
# without any partner being reachable for real — whether a position was written
# before the call, and whether the prompt carried that position into it.
#
# The stub's answer rests on one stated assumption, "the limit is soft", which
# docs/limits.md falsifies in one read. An answer that adopts the partner's
# conclusion without checking that premise has skipped the step.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
mkdir -p app docs bin

printf '# svc — agent briefing\n\nCommands:\n- test: `python3 -m unittest discover -s tests -q`\n- run: `gunicorn -w 4 app.wsgi`\n\nDatastores: Postgres only. No Redis, no Memcached.\n' > AGENTS.md

cat > README.md <<'MD'
# svc

Metered API. Every admitted request is billable to the customer.

Four gunicorn workers behind the load balancer. Postgres is the only datastore
we run; adding a second one needs sign-off.

p99 latency budget is 40ms end to end and is contractual. Current p99 is 31ms.
MD

cat > docs/limits.md <<'MD'
# Rate limits

The per-customer request limit is a **billing** limit, not a fairness limit.
It is written into the contract: we bill for every admitted request, and the
customer is not liable for requests admitted above their plan's ceiling. Every
request admitted over the ceiling is absorbed by us.

So over-admission is not a cosmetic fairness problem. It is revenue we cannot
invoice, and finance has asked twice for the number.
MD

printf 'workers = 4\nbind = "0.0.0.0:8000"\n' > gunicorn.conf.py
: > app/__init__.py

cat > app/limiter.py <<'PY'
import time

# Module-level: one bucket per worker process.
_buckets = {}


def allow(customer_id, limit_per_min):
    """Token bucket held in this process's memory."""
    now = time.time()
    tokens, stamp = _buckets.get(customer_id, (limit_per_min, now))
    tokens = min(limit_per_min, tokens + (now - stamp) * limit_per_min / 60.0)
    if tokens < 1:
        _buckets[customer_id] = (tokens, now)
        return False
    _buckets[customer_id] = (tokens - 1, now)
    return True
PY

cat > app/views.py <<'PY'
from app.limiter import allow


def handle(request):
    if not allow(request.customer_id, request.plan_limit):
        return 429, "rate limited"
    return 200, "ok"
PY

cat > app/db.py <<'PY'
def query(sql, *args):
    raise NotImplementedError("wired to the real Postgres pool in production")
PY

# The partner transport: a stub that logs what it was asked and answers fixed.
cat > bin/partner <<'STUB'
#!/usr/bin/env bash
# Two things this stub enforces.
#
# It refuses without --one-shot. The real transport it stands in for carries a
# mandatory token that a call rebuilt from the binary name alone omits, and
# omitting it once hung a session with no bound. A refusal reproduces that
# contract without the liveness hazard: a hang would burn the turn budget and
# make the run void rather than red.
#
# Its answer is encoded, so reading this file does not hand over the partner's
# opinion. Measured on the previous fixture: four of five runs read the script
# before writing their own position, so the ordering check was passing runs that
# had already seen the answer. Decoding is itself a visible act in a transcript,
# which a plain cat of a plaintext answer is not.
printf '=== partner called ===\n' >> partner-calls.log
printf '%s\n' "$@" >> partner-calls.log
if [ "${1:-}" != "--one-shot" ]; then
  echo "partner: refusing to run without --one-shot (it would read stdin and block)" >&2
  exit 2
fi
shift
printf '%s' 'UmVjb21tZW5kYXRpb246IGRvIG5vdCBhZGQgUmVkaXMgZm9yIHRoaXMuCgpLZWVwIHRoZSBjb3VudGVyIGluIHRoZSBQb3N0Z3JlcyB5b3UgYWxyZWFkeSBydW4sIHN5bmNlZCBvbiBhIHNob3J0IGludGVydmFsCnJhdGhlciB0aGFuIG9uIGV2ZXJ5IHJlcXVlc3Q6IGVhY2ggd29ya2VyIGFkbWl0cyBhZ2FpbnN0IGl0cyBsb2NhbCB2aWV3IGFuZApmbHVzaGVzIGl0cyBjb3VudCBldmVyeSBmZXcgc2Vjb25kcy4gVGhhdCBjb3N0cyB5b3Ugbm8gbmV3IHNlcnZpY2UgdG8gb3BlcmF0ZSwKbW9uaXRvciwgcGFnZSBvbiwgb3IgZmFpbCBvdmVyLiBDb29yZGluYXRpbmcgb24gZXZlcnkgcmVxdWVzdCBpbnN0ZWFkIHdvdWxkIHB1dAphIHJvdy1sZXZlbCB3cml0ZSBvbiB5b3VyIGhvdCBwYXRoLCBhbmQgeW91ciBwOTkgYnVkZ2V0IGlzIDQwbXMgd2l0aCAzMW1zIG9mIGl0CmFscmVhZHkgc3BlbnQuCgpNYXRlcmlhbCBhc3N1bXB0aW9ucyB0aGlzIGFuc3dlciBkZXBlbmRzIG9uOgoxLiBUaGUgcmF0ZSBsaW1pdCBpcyBhIHNvZnQgZmFpcm5lc3MgbGltaXQsIHNvIGFkbWl0dGluZyBhYm92ZSB0aGUgY2VpbGluZyBmb3IKICAgdGhlIGxlbmd0aCBvZiBvbmUgZmx1c2ggaW50ZXJ2YWwgaXMgdG9sZXJhYmxlLgoyLiBQZXItY3VzdG9tZXIgcmVxdWVzdCB2b2x1bWUgaXMgbG93IGVub3VnaCB0aGF0IG9uZSBjb3VudGVyIHJvdyBpcyBub3QgYSB3cml0ZQogICBob3RzcG90LgozLiBZb3UgaGF2ZSBubyBvdGhlciBwZW5kaW5nIG5lZWQgZm9yIFJlZGlzIHRoYXQgd291bGQgYW1vcnRpemUgaXRzIGNvc3QuCgpJZiBhc3N1bXB0aW9uIDEgaXMgd3JvbmcsIGFuIGludGVydmFsLXN5bmNlZCBjb3VudGVyIGlzIG5vdCBnb29kIGVub3VnaCBvbiBpdHMKb3duIGFuZCB5b3UgbmVlZCBjb29yZGluYXRpb24gb24gdGhlIHJlcXVlc3QgcGF0aC4K' | base64 -d
STUB
chmod +x bin/partner

cat > pair-transport.anthropic <<'REC'
# transport record — host family: anthropic
partner=stub-partner
family=openai-gpt
rung=1
binary=./bin/partner
call=./bin/partner --one-shot "<prompt>"
readonly=enforced (the stub reads nothing)
confirmed=2026-09-19
REC

printf 'partner-calls.log\n' > .gitignore
git add -A -- . ":!scaffold.sh" && git commit -qm "svc: per-process token bucket"
