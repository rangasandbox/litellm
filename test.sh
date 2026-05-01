#!/bin/bash

# Load env vars from .env
export $(grep -v '^#' .env | xargs)

# Allow overriding host, default to localhost
HOST="${LITELLM_HOST:-localhost}"

echo "Testing LiteLLM proxy at http://${HOST}:4000 ..."

curl -s "http://${HOST}:4000/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" \
  -d '{
    "model": "gpt-5.4",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "What are 3 things to visit in Seattle?"}
    ]
  }' | python3 -m json.tool
