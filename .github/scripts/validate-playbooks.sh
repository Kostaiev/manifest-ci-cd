set -euo pipefail

: "${SSH_KEY:?Missing ANSIBLE_SSH_KEY}"

umask 077

key=$(mktemp "$RUNNER_TEMP/ansible-key.XXXXXX")
trap 'rm -f "$key"' EXIT

printf '%s\n' "$SSH_KEY" > "$key"

export ANSIBLE_PRIVATE_KEY_FILE="$key"

# Check inventory
ansible-inventory --list |
jq -e '.managed_linux.hosts | length > 0' \
    > /dev/null

# Syntax + Check mode for every playbook
jq -r '.components[].playbook' \
    ../.github/components.json |
    while IFS= read -r playbook; do

playbook="${playbook#ansible/}"

echo "Validating: $playbook"

ansible-playbook \
    --syntax-check "$playbook"

ansible-playbook \
    --check "$playbook"

done
