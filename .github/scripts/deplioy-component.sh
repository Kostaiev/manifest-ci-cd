set -euo pipefail

: "${SSH_KEY:?Missing ANSIBLE_SSH_KEY}"

umask 077

key=$(mktemp "$RUNNER_TEMP/ansible-key.XXXXXX")
trap 'rm -f "$key"' EXIT

printf '%s\n' "$SSH_KEY" > "$key"

export ANSIBLE_PRIVATE_KEY_FILE="$key"

playbook=$(jq -er \
    --arg id "$COMPONENT" \
    '.components[$id].playbook' \
    ../.github/components.json)

playbook="${playbook#ansible/}"

echo "Deploying: $COMPONENT"

ansible-playbook "$playbook"
