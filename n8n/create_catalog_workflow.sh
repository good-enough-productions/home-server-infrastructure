#!/bin/bash

API_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0N2NkYjUyYi02MjU0LTQzZTYtYWIyNi05M2E2MGE4OTc0NmEiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY0MDE3MTkyfQ.sXj2CPKgzLHr6tLFRxwkVyDCl_mC4GbMZU-KQZJlGvQ"
BASE_URL="http://localhost:5678/api/v1"

# 1. Create Postgres Credential
echo "Creating Postgres Credential..."
CRED_JSON='{
  "name": "Personal Postgres",
  "type": "postgres",
  "data": {
    "host": "personal_db",
    "user": "admin",
    "password": "Pepsiguy1!Postgres",
    "database": "personal_projects",
    "port": 5432,
    "ssl": "disable"
  }
}'

CRED_RESPONSE=$(curl -s -X POST "$BASE_URL/credentials" \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$CRED_JSON")

# Extract Credential ID
CRED_ID=$(echo $CRED_RESPONSE | jq -r '.id')

if [ "$CRED_ID" == "null" ]; then
  echo "Failed to create credential. Response: $CRED_RESPONSE"
  echo "Proceeding to create workflow without linking credentials..."
  CRED_BLOCK=""
else
  echo "Credential created with ID: $CRED_ID"
  CRED_BLOCK='"credentials": { "postgres": { "id": "'$CRED_ID'", "name": "Personal Postgres" } },'
fi

# 2. Create Workflow using that Credential
echo "Creating Workflow..."

# Note: We inject the CRED_ID into the JSON
WORKFLOW_JSON='{
  "name": "Bonus: Query Node Catalog",
  "nodes": [
    {
      "parameters": {},
      "name": "On clicking execute",
      "type": "n8n-nodes-base.manualTrigger",
      "typeVersion": 1,
      "position": [
        250,
        300
      ]
    },
    {
      "parameters": {
        "operation": "executeQuery",
        "query": "SELECT * FROM n8n_nodes WHERE category = \u0027Trigger\u0027;"
      },
      "name": "Postgres",
      "type": "n8n-nodes-base.postgres",
      "typeVersion": 1,
      "position": [
        450,
        300
      ],
      '$CRED_BLOCK'
      "id": "postgres-node"
    }
  ],
  "connections": {
    "On clicking execute": {
      "main": [
        [
          {
            "node": "Postgres",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "settings": {}
}'

curl -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$WORKFLOW_JSON"

echo -e "\n\nDone! Check your n8n dashboard for 'Bonus: Query Node Catalog'."
