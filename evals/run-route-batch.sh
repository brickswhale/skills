#!/usr/bin/env bash
# run-route-batch.sh <workdir> [runs per case, default 5]
# Both route cases, in parallel, through run-route-case.sh. While the batch runs,
# the machine's real route and pair data folders, where they exist, are
# read-only, so no run can overwrite the owner's real setup (owner, 2026-10-02);
# they are restored on exit, and the batch says whether either one changed.
set -u
S="$1"; N="${2:-5}"
R=$(cd "$(dirname "$0")/.." && pwd)
DIRS=("$HOME/.config/route" "$HOME/.config/pair")
snap() { for d in "${DIRS[@]}"; do if [ -d "$d" ]; then (cd "$d" && find . -type f -exec shasum {} + | sort); else echo "absent $d"; fi; done; }
before=$(snap)
locked=()
for d in "${DIRS[@]}"; do [ -d "$d" ] && chmod -R a-w "$d" && locked+=("$d"); done
restore() { for d in ${locked[@]+"${locked[@]}"}; do chmod -R u+w "$d"; done; }
trap restore EXIT
mkdir -p "$S"
for n in $(seq 1 "$N"); do
  bash "$R/evals/run-route-case.sh" route-setup skill "$n" "$S" > "$S/setup-$n.log" 2>&1 &
  bash "$R/evals/run-route-case.sh" route-update skill "$n" "$S" > "$S/update-$n.log" 2>&1 &
done
wait
cat "$S"/*.log
[ "$before" = "$(snap)" ] && echo "real data folders unchanged" || echo "WARNING: a real data folder changed during the batch"
