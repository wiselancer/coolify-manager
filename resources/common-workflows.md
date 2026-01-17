# Common Workflows & Recipes

## 🛠️ Application Management

### Syncing Environment Variables
If the user provides a list of variables or a `.env` file content:
1. Create a temporary file `.env.temp`.
2. Run: `coolify app env sync <uuid> --file .env.temp`
3. Delete the temp file.

### Changing Domains
To update the URL of an application:
`coolify app update <uuid> --domains "https://new-domain.com,https://www.new-domain.com"`

## 🕵️ Logs & Debugging

### The Build failed instantly
Check the deployment history first.
`coolify app deployments list <uuid>`
If the status is `failed`, grab the logs for that specific deployment ID:
`coolify app deployments logs <app_uuid> <deployment_uuid>`

### The App is running but returning 500 errors
This is usually a runtime issue, not a build issue.
`coolify app logs <uuid> --lines 100`

## 🖥️ Server & Infrastructure

### Adding a new Server
1. Add the private key first: `coolify private-key add my-key @/path/to/key`
2. Add the server: `coolify server add my-server 1.2.3.4 <key_uuid> --validate`
   *Always use `--validate` to ensure immediate feedback.*