#!/bin/bash

API_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0N2NkYjUyYi02MjU0LTQzZTYtYWIyNi05M2E2MGE4OTc0NmEiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY0MDE3MTkyfQ.sXj2CPKgzLHr6tLFRxwkVyDCl_mC4GbMZU-KQZJlGvQ"
BASE_URL="http://localhost:5678/api/v1"

echo "Setting up additional credentials..."

# 1. Header Auth for Android App / Chrome Extension
# This is used to secure your Webhooks so only your app can trigger them.
echo "Creating 'Home Server App Auth'..."
HEADER_AUTH_JSON='{
  "name": "Home Server App Auth",
  "type": "httpHeaderAuth",
  "data": {
    "name": "X-API-KEY",
    "value": "invincible-server-secret-key"
  }
}'

curl -s -X POST "$BASE_URL/credentials" \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$HEADER_AUTH_JSON"
echo -e "\nCreated Header Auth. Use 'X-API-KEY: invincible-server-secret-key' in your Android App."

# 2. MQTT Credential for Mosquitto
echo -e "\nCreating 'Mosquitto MQTT'..."
MQTT_JSON='{
  "name": "Mosquitto MQTT",
  "type": "mqtt",
  "data": {
    "passwordless": true,
    "ssl": false
  }
}'

curl -s -X POST "$BASE_URL/credentials" \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$MQTT_JSON"
echo -e "\nCreated MQTT Credential. If you set a password for Mosquitto later, update this credential."

echo -e "\n\nDone!"
