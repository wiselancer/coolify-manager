---
name: coolify-manager
description: Manage self-hosted infrastructure via Coolify. Use this to deploy apps, debug build failures, manage databases, and interact with the Coolify API.
---

# Coolify Infrastructure Manager

This skill allows you to manage a self-hosted Coolify instance. It handles deployment lifecycles, resource configuration, and advanced debugging.

## ✅ Prerequisites

Ensure the following tools are available in the environment:
1. **Coolify CLI** (`coolify`): Version 1.4.0+
2. **jq**: For parsing JSON output.
3. **curl**: For raw API calls.

## 🧠 Decision Tree

**Step 1: Analyze the User Request.**
Determine which of the following categories the request falls into and follow the instructions.

### A. "Fix it" / "Debug it" (Operations)
*User asks: "Why did the build fail?", "Show me logs", "Restart the service"*
1. **Check Broad Health:** 
   - Run `coolify resources list --format json` to get a structured status of all services.
   - Parse the JSON to identify resources with status `unhealthy`, `exited`, or `degraded`.
2. **Check App Status:** 
   - Run `coolify app get <uuid> --format json` to confirm current state.
3. **Get Logs:** 
   - If build failed: 
     - List deployments: `coolify app deployments list <app_uuid> --format json`
     - Get logs for the failed deployment: `coolify app deployments logs <app_uuid> <deployment_uuid>`
   - If runtime error: `coolify app logs <uuid>`.
4. **Action:** If stuck, `coolify app restart <uuid>`.

### B. "Change it" (Configuration)
*User asks: "Update environment variables", "Change the domain", "Add a database"*
1. **Consult Reference:** Read `resources/common-workflows.md` for specific command patterns.
2. **Environment Vars:** 
   - Use `coolify app env sync` with a temporary `.env` file for bulk updates.
   - Always verify changes with `coolify app env list <uuid> --format json`.

### C. "Delete it" (Destructive Operations)
*User asks: "Delete the project", "Remove this database"*
1. **Check CLI Support:** 
   - Operations like `coolify project delete` are **not supported** by the CLI.
2. **Use Raw API:** 
   - Retrieve full context: `coolify context get <context_name> --show-sensitive --format json` -> Extract `fqdn` and `token`.
   - Execute `curl -X DELETE` against variables. See `resources/api-reference.md`.
3. **Safety:** 
   - Never use `--force` unless explicitly requested.

## ⚡ Best Practices

1. **Machine-Readable Output:**
   - **ALWAYS** use `--format json` for `list` and `get` commands.
   - Use `jq` to parse specific fields (e.g., UUIDs) to avoid parsing errors from table formatting.

2. **Resource Discovery:**
   - If you don't know the UUID, search by listing resources: `coolify resources list --format json`.
   - **Always** prefer UUIDs over names for critical operations to avoid ambiguity.

3. **Handling CLI Gaps (Raw API):**
   - If the CLI lacks a feature, consult `resources/api-reference.md`.
   - **Pattern:**
     ```bash
     # 1. Get Credentials
     JSON=$(coolify context get default --show-sensitive --format json)
     URL=$(echo $JSON | jq -r .fqdn)
     TOKEN=$(echo $JSON | jq -r .token)
     
     # 2. Call API
     curl -X DELETE "$URL/api/v1/projects/<uuid>" -H "Authorization: Bearer $TOKEN"
     ```

## 📚 Resources

| File | Purpose |
|------|---------|
| `resources/cli-reference.md` | Complete CLI command reference |
| `resources/api-reference.md` | Raw API endpoints for operations the CLI doesn't support |
| `resources/common-workflows.md` | Recipes for common tasks (env sync, domain changes, etc.) |
| `guides/container_ssh.md` | How to SSH into containers manually |

## ⚠️ Known CLI Limitations & API Fallbacks

The Coolify CLI (v1.4.0) has gaps. Use the Raw API for:

| Operation | CLI Support | API Endpoint |
|-----------|-------------|--------------|
| Delete project | ❌ No | `DELETE /api/v1/projects/{uuid}` |
| Execute command in container | ❌ No | (No API) SSH to host + `docker exec` |
| Force delete database | ❌ No | `DELETE /api/v1/databases/{uuid}` |

  