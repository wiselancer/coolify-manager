# Coolify Raw API Reference

This document covers API endpoints that the CLI does **not** support. Use these when the CLI lacks a feature.

## 🔑 Authentication

All API requests require a Bearer token. Get your context credentials with:

```bash
coolify context get <context_name> --show-sensitive
```

This gives you:
- **FQDN** (e.g., `http://your-server-ip:8000`) → Your base URL
- **Token** → Your bearer token

### Request Format

```bash
curl '<BASE_URL>/api/v1/<endpoint>' \
  --header 'Authorization: Bearer <TOKEN>' \
  --header 'Content-Type: application/json'
```

---

## 📁 Projects

### List Projects
```bash
GET /api/v1/projects
```

### Get Project Details
```bash
GET /api/v1/projects/{uuid}
```

### Delete Project ⚠️
**Not available in CLI.** Use this endpoint:

```bash
DELETE /api/v1/projects/{uuid}
```

Example:
```bash
curl 'http://YOUR_HOST:8000/api/v1/projects/abc123-def456' \
  --request DELETE \
  --header 'Authorization: Bearer YOUR_TOKEN'
```

---

## 🚀 Applications

### List Applications
```bash
GET /api/v1/applications
```

### Get Application Details
```bash
GET /api/v1/applications/{uuid}
```

### Start Application
```bash
POST /api/v1/applications/{uuid}/start
```

### Stop Application
```bash
POST /api/v1/applications/{uuid}/stop
```

### Restart Application
```bash
POST /api/v1/applications/{uuid}/restart
```

### Delete Application
```bash
DELETE /api/v1/applications/{uuid}
```

---

## 🗄️ Databases

### List Databases
```bash
GET /api/v1/databases
```

### Get Database Details
```bash
GET /api/v1/databases/{uuid}
```

### Create Database
```bash
POST /api/v1/databases/{type}
```

Supported types: `postgresql`, `mysql`, `mariadb`, `mongodb`, `redis`, `keydb`, `clickhouse`, `dragonfly`

### Delete Database
```bash
DELETE /api/v1/databases/{uuid}
```

---

## 🖥️ Servers

### List Servers
```bash
GET /api/v1/servers
```

### Get Server Details
```bash
GET /api/v1/servers/{uuid}
```

### Get Server Resources
```bash
GET /api/v1/servers/{uuid}/resources
```

---

## 🔧 Services

### List Services
```bash
GET /api/v1/services
```

### Get Service Details
```bash
GET /api/v1/services/{uuid}
```

### Start Service
```bash
POST /api/v1/services/{uuid}/start
```

### Stop Service
```bash
POST /api/v1/services/{uuid}/stop
```

### Delete Service
```bash
DELETE /api/v1/services/{uuid}
```

---

## 📦 Deployments

### Deploy Application
```bash
POST /api/v1/deploy?uuid={app_uuid}
```

Optional query params:
- `force=true` - Force rebuild

### List Deployments
```bash
GET /api/v1/deployments
```

### Get Deployment Details
```bash
GET /api/v1/deployments/{uuid}
```

---

## ⚠️ Known Limitations

The following operations are **NOT available via API**:

1. **Execute commands inside containers** - No `docker exec` equivalent. Must SSH to host server manually.
2. **Stream logs in real-time** - Use CLI `coolify app logs -f` or poll the logs endpoint.

---

## 🛠️ Helper: Building curl Commands

To quickly construct a curl command from your current context:

```bash
# Get context info
CONTEXT=$(coolify context get <context_name> --show-sensitive --format json)
BASE_URL=$(echo $CONTEXT | jq -r '.fqdn')
TOKEN=$(echo $CONTEXT | jq -r '.token')

# Now use them
curl "$BASE_URL/api/v1/projects" \
  --header "Authorization: Bearer $TOKEN"
```
