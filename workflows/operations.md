# Operations Workflow
**Purpose:** Managing the lifecycle of deployments and debugging failures.

## 🔍 Debugging & Logs
**Scenario:** The user says "Why did my build fail?" or "Show me the server logs."

1. **Identify the Deployment:**
   - Run `coolify app deployments list <app_uuid>` to see history.
   - Look for status `failed` or `in_progress`.

2. **Retrieve Logs:**
   - **Build Logs:** `coolify app deployments logs <app_uuid> [deployment_uuid]`
   - **Runtime Logs:** `coolify app logs <uuid>` (Live logs from the running container).
   - *Tip:* Use `--debuglogs` if the error implies an internal system failure.

## 🚀 Deployment Actions
**Scenario:** User wants to update the site or restart a service.

- **Deploy:** `coolify deploy uuid <uuid>`
- **Restart:** `coolify app restart <uuid>` (Use this if the app is stuck/unresponsive).
- **Cancel:** `coolify deploy cancel <uuid>` (If a build is hanging).

## 💡 Heuristics for the Agent
- If the build logs are empty, the issue is likely in the `infrastructure.md` domain (e.g., Server disconnect).
- If runtime logs show "Connection Refused," check `workflows/applications.md` to verify Environment Variables.