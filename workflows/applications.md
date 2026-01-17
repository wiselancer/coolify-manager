# Application & Resource Management
**Purpose:** configuring the "What" — Apps, Databases, and Services.

## 📦 Resource Discovery
To act on a resource, you first need its UUID.
- `coolify projects list` -> Get Project UUID.
- `coolify projects get <project_uuid>` -> Lists all environments and resources within.

## 🛠️ Application Configuration
**Scenario:** User needs to change a domain, update git repo, or change build commands.

**Command:** `coolify app update <uuid> [flags]`
- **Common Flags:**
  - `--domains <domain>` (e.g., `https://api.myapp.com`)
  - `--install-command`, `--build-command`, `--start-command` (Critical for NextJS/Node apps)
  - `--ports-mappings "80:3000"` (Host:Container)

## 🔐 Environment Variables
**Scenario:** User needs to add an API Key or Database URL.
1. **List:** `coolify app env list <app_uuid>`
2. **Add:** `coolify app env create <app_uuid> --key <KEY> --value <VAL>`
   - *Note:* If the user provides a `.env` file, use `coolify app env sync --file <path>`.

## 🗄️ Databases
**Scenario:** User wants to create or backup a DB.
- **Create:** `coolify database create <type> --server-uuid <server> ...`
- **Backup:** `coolify database backup trigger <db_uuid> <backup_uuid>`