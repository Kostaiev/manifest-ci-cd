set -euo pipefail

    if [[ "$GITHUB_EVENT_NAME" == "push" ]]; then
      components="$CHANGED"
    else
      components=$(jq -c --arg id "$COMPONENT" '
        if $id == "all" then .components | keys
        elif (.components | has($id)) then [$id]
        else error("Unknown component: \($id)")
        end
      ' .github/components.json)
    fi

    echo "components=$components" >> "$GITHUB_OUTPUT"
