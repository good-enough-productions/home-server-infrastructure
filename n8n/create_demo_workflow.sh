#!/bin/bash

# API Key provided by user
API_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0N2NkYjUyYi02MjU0LTQzZTYtYWIyNi05M2E2MGE4OTc0NmEiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY0MDE3MTkyfQ.sXj2CPKgzLHr6tLFRxwkVyDCl_mC4GbMZU-KQZJlGvQ"

# n8n URL (Localhost since we are on the server)
N8N_URL="http://localhost:5678/api/v1/workflows"

# Workflow JSON Definition
# Creates a simple "Hello World" workflow with a Manual Trigger and a Debug node
WORKFLOW_JSON='{
  "name": "API Generated Demo Workflow",
  "nodes": [
    {
      "parameters": {},
      "name": "On clicking execute",
      "type": "n8n-nodes-base.manualTrigger",
      "typeVersion": 1,
      "position": [
        250,
        300
      ],
      "id": "trigger-node"
    },
    {
      "parameters": {
        "content": "Hello! This workflow was created via the n8n API."
      },
      "name": "Debug Helper",
      "type": "n8n-nodes-base.debugHelper",
      "typeVersion": 1,
      "position": [
        450,
        300
      ],
      "id": "debug-node"
    }
  ],
  "connections": {
    "On clicking execute": {
      "main": [
        [
          {
            "node": "Debug Helper",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "settings": {}
}'

# Execute curl request
echo "Creating workflow via API..."
curl -X POST "$N8N_URL" \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$WORKFLOW_JSON"

echo -e "\n\nDone! Check your n8n dashboard."
