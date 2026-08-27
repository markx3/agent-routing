#!/usr/bin/env bash
set -u
pr="${1:?usage: pr-watch.sh <pr-number> [active-interval] [idle-interval]}"
active="${2:-60}"
idle="${3:-300}"
fields='state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup,reviews,comments'
prev=""
failures=0
while true; do
  if ! json=$(gh pr view "$pr" --json "$fields" 2>&1); then
    failures=$((failures + 1))
    if [ "$failures" -ge 10 ]; then
      printf '{"error":"gh pr view failed %s times","last":%s}\n' "$failures" "$(printf '%s' "$json" | jq -Rs .)"
      exit 1
    fi
    sleep "$active"
    continue
  fi
  failures=0
  cur=$(printf '%s' "$json" | shasum | cut -d' ' -f1)
  if [ "$cur" != "$prev" ]; then
    printf '%s' "$json" | jq -c '{
      state, mergeable, mergeStateStatus, reviewDecision,
      checks: [.statusCheckRollup[]? | {name: (.name // .context), status: (.conclusion // .state // .status)}],
      reviews: [.reviews[]? | {author: .author.login, state, submittedAt}],
      comments: (.comments | length)
    }'
    prev="$cur"
  fi
  state=$(printf '%s' "$json" | jq -r .state)
  [ "$state" = "MERGED" ] || [ "$state" = "CLOSED" ] && exit 0
  pending=$(printf '%s' "$json" | jq '[.statusCheckRollup[]? | select((.conclusion // .state // .status) as $s | $s == null or $s == "PENDING" or $s == "IN_PROGRESS" or $s == "QUEUED")] | length')
  if [ "$pending" -gt 0 ]; then sleep "$active"; else sleep "$idle"; fi
done
