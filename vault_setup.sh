#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Start Vault server in dev mode and capture output
echo "Starting Vault in dev mode..."
VAULT_LOG="/tmp/vault_dev.log"
vault server -dev > "$VAULT_LOG" 2>&1 &
VAULT_PID=$!

# Give Vault a few seconds to initialize
sleep 3

# Extract the Vault root token from the log output
VAULT_TOKEN=$(grep 'Root Token:' "$VAULT_LOG" | awk '{print $NF}')

# Export environment variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN

echo "Vault address: $VAULT_ADDR"
echo "Vault token: $VAULT_TOKEN"

# List enabled secrets engines
echo "Listing Vault secrets engines..."
vault secrets list

# Add a new secret
echo "Writing secret to secret/langflow..."
vault kv put secret/gemini llmkey="changeme"
vault kv put secret/airs airskey="changeme"

# Final message
echo "Vault is running locally. All secrets are ready for consumption in Langflow..."
