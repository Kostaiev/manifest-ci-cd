#!/usr/bin/env bash
set -euo pipefail

jq -ce --argjson ids "${1:?Pass JSON array}" '
  .components as $c |

  def resolve($id; $stack):
    if ($stack | index($id)) != null then
      error("Cycle: \($id)")
    elif $c[$id] == null then
      error("Unknown component: \($id)")
    elif ($c[$id].depends_on | type) != "array" then
      error("Invalid depends_on: \($id)")
    else
      ($c[$id].depends_on[] | resolve(.; $stack + [$id])), $id
    end;

  if .version != 1 or ($ids | type) != "array" then
    error("Invalid input")
  else
    [$ids[] | resolve(.; [])]
    | reduce .[] as $id ([];
        if index($id) == null then . + [$id] else . end
      )
  end
' .github/components.json