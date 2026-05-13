# Forgejo Repository Setup Guide

**Status:** Pending repository creation on 192.168.3.174  
**Goal:** Configure Forgejo as the primary remote for dotfiles repository  
**Current State:** Local git repository committed; remote push blocked

---

## Current Situation

- **Server:** 192.168.3.174 is running Nginx Proxy Manager (reverse proxy)
- **Expected URL:** http://192.168.3.174/bobby/dotfiles.git
- **Issue:** Forgejo service is not responding at this URL
- **Local Status:** Git repository initialized with 1 commit (f759385), ready to push

---

## What Needs to Happen

### Option 1: Install Forgejo on 192.168.3.174 (Recommended)

If 192.168.3.174 is your dedicated Forgejo server:

1. **SSH to 192.168.3.174** and install Forgejo
   ```bash
   # Download latest Forgejo binary
   # Follow official docs: https://forgejo.org/docs/
   ```

2. **Start the Forgejo service** (typically on port 3000)
   ```bash
   # Service should listen on localhost:3000
   ```

3. **Configure in Nginx Proxy Manager:**
   - Admin Panel → Proxy Hosts → Add Proxy Host
   - Domain: `192.168.3.174` (or your FQDN)
   - Forward to: `localhost:3000`
   - Save and enable

4. **Create the repository via Forgejo UI or API:**
   ```bash
   curl -X POST "http://192.168.3.174/api/v1/user/repos" \
     -H "Authorization: token d31575cf702772d940f0192d3c4e73a2d451a83b" \
     -H "Content-Type: application/json" \
     -d '{
       "name": "dotfiles",
       "description": "Cross-device dotfiles and configuration management",
       "private": false,
       "auto_init": false
     }'
   ```

5. **Push the repository:**
   ```bash
   cd /path/to/dotfiles
   git push -u origin main
   ```

### Option 2: Alternative Repository Location

If you want to use a different server for Forgejo:

1. **Update the git remote:**
   ```bash
   git remote set-url origin http://YOUR_FORGEJO_SERVER/bobby/dotfiles.git
   ```

2. **Create the repository on your Forgejo instance**

3. **Push:**
   ```bash
   git push -u origin main
   ```

---

## Next Steps

Once Forgejo is properly configured and the repository is created:

1. ✓ Local repository is ready (commit: f759385)
2. ⏳ Forgejo must be installed/configured on 192.168.3.174
3. ⏳ Remote repository must be created
4. ⏳ Push with: `git push -u origin main`
5. ⏳ Verify push succeeded with: `git log --oneline -5` (to see commit history)

---

## Current Git Status

```bash
# Remote configured:
git remote -v
# Output: origin http://192.168.3.174/bobby/dotfiles.git (fetch)
#         origin http://192.168.3.174/bobby/dotfiles.git (push)

# Commits ready:
git log --oneline
# Output: f759385 Initial commit: Comprehensive onboarding and dotfiles setup

# Untracked files on main branch (not critical, can be added later):
# .obsidian/, .vscode/, code/, documents/, homelab/, writing/
```

---

## API Key Reference

Your provided Forgejo API key:
```
d31575cf702772d940f0192d3c4e73a2d451a83b
```

This token is valid for API operations once Forgejo is accessible.

---

## Troubleshooting

**"404 Not Found" on API calls:**
- Forgejo service is not responding at the configured URL
- Check if Forgejo is installed and running
- Verify Nginx Proxy Manager is correctly forwarding requests

**"fatal: repository not found":**
- Repository doesn't exist on Forgejo yet
- Create it via UI or API (see Option 1, step 4)

**API key not working:**
- Verify token in Forgejo user settings
- Ensure token hasn't expired

