#!/usr/bin/env bash
set -euo pipefail

: "${TELEGRAM_BOT_TOKEN:?Missing bot token}"
: "${TELEGRAM_CHAT_ID:?Missing chat ID}"
: "${MESSAGE:?Missing message}"

curl -fsS \
  --connect-timeout 5 \
  --max-time 15 \
  --output /dev/null \
  --request POST \
  --data-urlencode "chat_id=$TELEGRAM_CHAT_ID" \
  --data-urlencode "text=$MESSAGE" \
  "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
