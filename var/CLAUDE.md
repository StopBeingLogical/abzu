# Mneme Metadata Store — Session Seed & Instructions

**Purpose:** Central metadata repository for the entire filestore  
**Status:** Active expansion  
**Maintenance:** Changelog system in `.changelog/UNRELEASED.md`

---

## Session Start Checklist

When you start a session on var/:

1. **Load metadata context** (1 min)
   - Review structure: `prompts/`, `workspaces/`, _(more coming)_
   - Check CHANGELOG.md for recent metadata additions

2. **Check for changelog updates** (1 min)
   - Ask: "Should I consolidate pending changelog entries from `.changelog/UNRELEASED.md` into the appropriate CHANGELOG.md files?"
   - If yes: move one-liners to their destination files and reset UNRELEASED.md
   - If no: continue

3. **Add/update metadata**
   - Add new prompts to `prompts/` with documentation
   - Update workspace configs as needed
   - Populate new metadata categories as they're created

---

## Changelog Maintenance

**Location:** `.changelog/UNRELEASED.md` (working file), `**/CHANGELOG.md` (committed files)

**When making changes:**
- Add one-liners to `.changelog/UNRELEASED.md` when adding prompts, updating indexes, creating new metadata categories
- At session start, I'll ask if you want to consolidate entries
- Before committing, I'll move entries to the appropriate CHANGELOG.md files

---

## Project Structure

```
var/
├── prompts/           Task-specific and general prompts (with indexes & CoT)
├── workspaces/        VS Code workspace configurations
├── CHANGELOG.md       Top-level changelog
├── CLAUDE.md          This file
└── .changelog/        Working changelog entries
```

**Future expansion:** You mentioned more folders coming. When you add them (config/, templates/, etc.), we'll expand the changelog structure accordingly.

---

## Quick Links

| I want to... | Do this... |
|---|---|
| View metadata evolution | See `CHANGELOG.md` |
| Add a prompt | Create `.md` in `prompts/` and update `.changelog/UNRELEASED.md` |
| Create prompt index | Document in `prompts/INDEX.md` and note in changelog |
| Track CoT | Add to `prompts/` with documentation |
| Update workspace | Edit `.code-workspace` file and note in `.changelog/UNRELEASED.md` |

---

## Important Notes

- **Prompts library:** Include indexes and chain-of-thought documentation for certain prompts as you build this out
- **Indexing:** Consider creating `prompts/INDEX.md` for quick discovery as the library grows
- **Expansion:** Ready to add new metadata categories as you define them

---

## Repository

**Location:** `~/nextcloud/Mneme/var/`  
**Role:** Central metadata hub  
**Last updated:** April 23, 2026
