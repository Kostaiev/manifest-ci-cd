set -euo pipefail

jq -e '
    .components as $c
    | .version == 1
     and ($c | type == "object" and length > 0)
    and all($c | to_entries[];
            (.key | test("^[a-z0-9-]+$"))
            and
            (.value.paths |
              type == "array"
              and length > 0
              and all(.[];
                type == "string" and length > 0
              )
            )
            and
            (.value.playbook |
              type == "string"
              and startswith("ansible/playbooks/")
              and (
                endswith(".yml")
                or endswith(".yaml")
              )
            )
          )
' .github/components.json > /dev/null

jq -r '.components[].playbook' \
    .github/components.json |
    while IFS= read -r playbook; do
    test -f "$playbook"
done
