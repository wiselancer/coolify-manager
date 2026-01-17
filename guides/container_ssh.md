# Infrastructure Management
**Purpose:** Managing the "Where" — Servers, Teams, and Authentication.

## 🖥️ Servers
**Scenario:** Adding capacity or checking connection status.
- **List:** `coolify server list` (Returns IPs and UUIDs).
- **Validate:** `coolify server validate <uuid>` (Run this if deployments are timing out).
- **Metadata:** `coolify server get <uuid> --resources` (Shows what is running on this server).

## 🔑 Access & Context
- **Contexts:** `coolify context use <name>` (Switch between Self-Hosted and Cloud).
- **Private Keys:** `coolify private-key add <name> <file>` (Needed for GitHub cloning or Server SSH).

## 🐙 GitHub Integration
**Scenario:** User can't see their repositories.
1. Check `coolify github list`.
2. Ensure the App ID and Installation ID match the GitHub settings.
3. Use `coolify github repos <app_uuid>` to verify visibility.