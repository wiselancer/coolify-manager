#!/bin/bash
# Description: Tunnels through the host server to execute commands inside a specific Coolify container.
# Usage: ./container-exec.sh <app_uuid> <command_to_run>

APP_UUID=$1
CMD=$2

if [ -z "$APP_UUID" ]; then
  echo "Error: App UUID is required."
  exit 1
fi

# 1. Get the Server UUID for this app
SERVER_UUID=$(coolify app get "$APP_UUID" --format json | jq -r '.server_uuid')

if [ -z "$SERVER_UUID" ] || [ "$SERVER_UUID" == "null" ]; then
  echo "Error: Could not find server for App UUID: $APP_UUID"
  exit 1
fi

# 2. Get Server Credentials
SERVER_INFO=$(coolify server get "$SERVER_UUID" --format json)
SERVER_IP=$(echo "$SERVER_INFO" | jq -r '.ip')
SERVER_USER=$(echo "$SERVER_INFO" | jq -r '.user')
SERVER_PORT=$(echo "$SERVER_INFO" | jq -r '.port')

# 3. Find the Docker Container ID on the remote server
# We grep for the UUID because Coolify tags containers with it.
CONTAINER_ID=$(ssh -p $SERVER_PORT $SERVER_USER@$SERVER_IP "docker ps --format '{{.ID}}' --filter name=$APP_UUID | head -n 1")

if [ -z "$CONTAINER_ID" ]; then
  echo "Error: No running container found for app $APP_UUID on server $SERVER_IP"
  exit 1
fi

# 4. Execute the command
echo "Connecting to $SERVER_IP -> Container $CONTAINER_ID..."
ssh -t -p $SERVER_PORT $SERVER_USER@$SERVER_IP "docker exec -it $CONTAINER_ID $CMD"