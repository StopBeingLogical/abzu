# Bobby's Comprehensive Onboarding Guide

**Purpose:** Complete setup and replication guide for all systems, applications, and customizations across macOS, Linux, and Windows.

**Last Updated:** May 13, 2026

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core Setup (All Devices)](#core-setup)
4. [Module 1: Seed System](#module-1-seed-system)
5. [Module 2: Micro Editor](#module-2-micro-editor)
6. [Module 3: Starship Prompt](#module-3-starship-prompt)
7. [Module 4: Pi Coding Agent](#module-4-pi-coding-agent) [TODO]
8. [Module 5: Claude Code CLI](#module-5-claude-code-cli) [TODO]
9. [Module 6: Claude Desktop](#module-6-claude-desktop) [TODO]
10. [Module 7: Gemini CLI](#module-7-gemini-cli) [TODO]
11. [Module 8: Gemini Desktop](#module-8-gemini-desktop) [TODO]
12. [Module 9: OpenCode](#module-9-opencode) [TODO]
13. [Module 10: tmux](#module-10-tmux) [TODO]
14. [Module 11: llama-cpp / llama-swap](#module-11-llama-cpp--llama-swap)
15. [General Troubleshooting](#general-troubleshooting)
16. [Clean OS Wipe Recovery](#clean-os-wipe-recovery)
17. [Quick Reference](#quick-reference)

---

## Overview

This guide covers replication of your entire development environment across three devices:

- **macOS** (M1 Max MacBook Pro) – Primary dev machine
- **Linux** (Headless) – Homelab infrastructure
- **Windows** (Latitude) – Portable sessions

All configuration lives in **Nextcloud (Atlas)** and syncs across devices. Environment variables, shell profiles, and application configs are OS-aware.

**Modules:**
- **Seed System** – Multi-agent LLM seed file (Claude Code, Pi, OpenCode, Gemini)
- **[Applications & Customizations]** – Placeholder for additional modules (micro editor, shell configs, dotfiles, etc.)

---

## Architecture

```
┌─────────────────────────────────────────┐
│  Atlas (Infrastructure Server)          │
│  └─ Nextcloud Instance (Centralized)   │
│     ├─ /Mneme/var/SEED.md              │
│     ├─ /Mneme/var/seed-parser.sh       │
│     ├─ /Mneme/var/[other configs]      │
│     └─ ONBOARDING.md (this file)        │
└─────────────────────────────────────────┘
         ↑              ↑              ↑
         │              │              │
  ┌──────┴──────┐  ┌────┴─────┐  ┌────┴──────┐
  │   macOS     │  │  Linux   │  │  Windows  │
  │ Nextcloud   │  │ nextcloud│  │ nextcloud │
  │ Client      │  │ Client   │  │ Client    │
  │ (capital N) │  │ (lower)  │  │ (lower)   │
  └──────┬──────┘  └────┬─────┘  └────┬──────┘
         │              │              │
   ~/.zshrc        ~/.bashrc      PowerShell
   SEED_FILE      SEED_FILE        $PROFILE
   other vars     other vars       $env: vars
         │              │              │
         └──────┬───────┴──────┬───────┘
                │              │
         Per-module sync parsers/scripts
         (seeds, applications, customizations)
```

---

## Core Setup

### Step 0: Prerequisites (All Devices)

Before starting any module:

1. **Nextcloud client installed** – Syncing with Atlas
2. **Nextcloud folder synced** – `~/Nextcloud/` (macOS) or `~/nextcloud/` (Linux/Windows)
3. **Shell profile exists** – `~/.zshrc` (macOS), `~/.bashrc` (Linux), `$PROFILE` (Windows PowerShell)

---

### Step 1: Environment Variables (OS-Specific)

Each module requires environment variables pointing to Nextcloud-synced sources. Set these first, in your shell profile.

#### macOS (~/.zshrc)

```bash
# Nextcloud paths
export NEXTCLOUD_HOME="$HOME/Nextcloud/Mneme"

# Module: Seed System
export SEED_FILE="$NEXTCLOUD_HOME/var/SEED.md"

# Module: Micro Editor (reference only, used in setup)
export MICRO_DOTFILES="$NEXTCLOUD_HOME/var/dotfiles/micro"

# Module: Starship Prompt (reference only, used in setup)
export STARSHIP_DOTFILES="$NEXTCLOUD_HOME/var/dotfiles/starship"
export STARSHIP_FONTS="$NEXTCLOUD_HOME/var/dotfiles/fonts/cascadia-nerd-fonts"

# Module: [Add other module vars here]
# export [MODULE]_FILE="$NEXTCLOUD_HOME/var/[config]"

# Ensure PATH includes local bin
export PATH="$HOME/.local/bin:$PATH"
```

#### Linux (~/.bashrc)

```bash
# Nextcloud paths
export NEXTCLOUD_HOME="$HOME/nextcloud/Mneme"

# Module: Seed System
export SEED_FILE="$NEXTCLOUD_HOME/var/SEED.md"

# Module: Micro Editor (reference only, used in setup)
export MICRO_DOTFILES="$NEXTCLOUD_HOME/var/dotfiles/micro"

# Module: Starship Prompt (reference only, used in setup)
export STARSHIP_DOTFILES="$NEXTCLOUD_HOME/var/dotfiles/starship"
export STARSHIP_FONTS="$NEXTCLOUD_HOME/var/dotfiles/fonts/cascadia-nerd-fonts"

# Module: [Add other module vars here]
# export [MODULE]_FILE="$NEXTCLOUD_HOME/var/[config]"

# Ensure PATH includes local bin
export PATH="$HOME/.local/bin:$PATH"
```

#### Windows (PowerShell $PROFILE)

```powershell
# Nextcloud paths
$env:NEXTCLOUD_HOME = "$env:USERPROFILE\nextcloud\Mneme"

# Module: Seed System
$env:SEED_FILE = "$env:NEXTCLOUD_HOME\var\SEED.md"

# Module: Micro Editor (reference only, used in setup)
$env:MICRO_DOTFILES = "$env:NEXTCLOUD_HOME\var\dotfiles\micro"

# Module: Starship Prompt (reference only, used in setup)
$env:STARSHIP_DOTFILES = "$env:NEXTCLOUD_HOME\var\dotfiles\starship"
$env:STARSHIP_FONTS = "$env:NEXTCLOUD_HOME\var\dotfiles\fonts\cascadia-nerd-fonts"

# Module: [Add other module vars here]
# $env:[MODULE]_FILE = "$env:NEXTCLOUD_HOME\var\[config]"

# Ensure PATH includes local bin
$env:Path += ";$env:USERPROFILE\.local\bin"
```

**Verify:** After adding to profile, open new terminal:
```bash
echo $SEED_FILE  # or $env:SEED_FILE on Windows
# Should show correct path
```

---

### Step 2: Create Local Directories

```bash
# macOS/Linux
mkdir -p ~/.local/bin
mkdir -p ~/.config

# Windows PowerShell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.local\bin"
New-Item -ItemType Directory -Force -Path "$env:APPDATA"
```

---

## Module 1: Seed System

### Overview

Centralized seed file for all LLM agents (Claude Code, Pi, OpenCode, Gemini). Single source of truth; all agents stay synced.

**Files:**
- Source: `~/nextcloud/Mneme/var/SEED.md` (Nextcloud)
- Parser: `~/nextcloud/Mneme/var/seed-parser.sh` (Nextcloud)
- Outputs: Agent-specific configs in device home directories

---

### Setup: Seed System

#### Step 1: Install Parser Script

##### macOS & Linux

```bash
# Copy parser from Nextcloud (avoids sync locks)
SEED_LOCATION="$(echo $SEED_FILE | sed 's/SEED.md$/seed-parser.sh/')"
cp "$SEED_LOCATION" ~/.local/bin/seed-parser
chmod +x ~/.local/bin/seed-parser

# Verify
seed-parser --help
```

##### Windows (PowerShell)

```powershell
# Parser called directly from Nextcloud in alias (next step)
# Just verify path is accessible:
Test-Path "$env:USERPROFILE\nextcloud\Mneme\var\seed-parser.sh"
# Should return: True
```

#### Step 2: Create Sync Alias

##### macOS & Linux

Add to shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Mneme seed sync alias
alias sync-seeds='seed-parser && echo "✓ All seeds synced"'
```

##### Windows (PowerShell)

Add to `$PROFILE`:

```powershell
function Sync-Seeds {
  & "$env:USERPROFILE\nextcloud\Mneme\var\seed-parser.sh"
  Write-Host "✓ All seeds synced" -ForegroundColor Green
}
```

#### Step 3: First Run

```bash
# macOS/Linux
sync-seeds

# Windows
Sync-Seeds
```

This generates:
- `~/.claude/claude.md`
- `~/.pi/agent/AGENTS.md`
- `~/.gemini/settings.json`
- `~/.config/opencode/opencode.json`

#### Step 4: Verify Outputs

```bash
# macOS/Linux
ls -lh ~/.claude/claude.md ~/.pi/agent/AGENTS.md ~/.gemini/settings.json ~/.config/opencode/opencode.json

# Windows PowerShell
Get-Item ~\.claude\claude.md, ~\.pi\agent\AGENTS.md, ~\.gemini\settings.json, ~\.config\opencode\opencode.json
```

---

### Workflow: Seed System

**Update SEED.md:**
```bash
vim ~/nextcloud/Mneme/var/SEED.md
sync-seeds  # or Sync-Seeds on Windows
```

**Cross-device sync:**
- Edit on any device → Nextcloud syncs (~5-30 seconds) → Run `sync-seeds` on other devices

---

## Module 2: Micro Editor

### Overview

Terminal text editor with custom TokyoNight colorscheme. Configuration synced from Nextcloud across all devices.

**Files:**
- Source: `~/nextcloud/Mneme/var/dotfiles/micro/` (Nextcloud)
  - `settings.json` – Editor config (colorscheme, options)
  - `colorschemes/tokyonight.micro` – Custom colorscheme
- Target: Device micro config directory (OS-specific)

**Features configured:**
- Colorscheme: TokyoNight (dark, minimal)
- mkparents: Auto-create parent directories on save
- Extensible: Add more configs/colorschemes as needed

---

### Setup: Micro Editor

#### Step 1: Verify Micro is Installed

##### macOS

```bash
# Install via homebrew if not present
brew install micro

# Verify
micro --version
```

##### Linux

```bash
# Install via package manager
sudo apt install micro   # Debian/Ubuntu
# or
sudo dnf install micro   # Fedora/RHEL

# Verify
micro --version
```

##### Windows (PowerShell)

```powershell
# Install via package manager
scoop install micro
# or
choco install micro

# Verify
micro --version
```

#### Step 2: Create Micro Config Directory

##### macOS & Linux

```bash
mkdir -p ~/.config/micro/colorschemes
```

##### Windows (PowerShell)

```powershell
New-Item -ItemType Directory -Force -Path "$env:APPDATA\micro\colorschemes"
```

#### Step 3: Install Configuration Files

##### macOS & Linux

**Option A: Symlink (Recommended - Auto-updates)**

```bash
# Create symlinks to Nextcloud (files auto-update when Nextcloud syncs)
ln -s ~/nextcloud/Mneme/var/dotfiles/micro/settings.json ~/.config/micro/settings.json

mkdir -p ~/.config/micro/colorschemes
ln -s ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/tokyonight.micro ~/.config/micro/colorschemes/tokyonight.micro

# Verify
ls -la ~/.config/micro/
```

**Option B: Copy (Manual updates)**

```bash
# Copy settings
cp ~/nextcloud/Mneme/var/dotfiles/micro/settings.json ~/.config/micro/

# Copy colorscheme
cp ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/tokyonight.micro ~/.config/micro/colorschemes/

# Verify
ls -la ~/.config/micro/
```

##### Windows (PowerShell)

```powershell
# Copy settings
Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\micro\settings.json" -Destination "$env:APPDATA\micro\"

# Copy colorscheme
Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\micro\colorschemes\tokyonight.micro" -Destination "$env:APPDATA\micro\colorschemes\"

# Verify
Get-ChildItem "$env:APPDATA\micro\"
```

#### Step 4: Verify Setup

Open micro and verify colorscheme loads:

```bash
micro  # Open editor
```

Should see TokyoNight colors (dark background, colorful syntax highlighting).

Type `:quit` or `Ctrl+Q` to exit.

---

### Workflow: Micro Editor

**Update settings or colorscheme:**

```bash
# 1. Edit files in Nextcloud
vim ~/nextcloud/Mneme/var/dotfiles/micro/settings.json
# or
vim ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/tokyonight.micro

# 2. Copy to device's micro config
cp ~/nextcloud/Mneme/var/dotfiles/micro/settings.json ~/.config/micro/
cp ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/tokyonight.micro ~/.config/micro/colorschemes/

# 3. Reload micro
# (Restart micro or use :reload command)
```

**Add new colorscheme:**

```bash
# 1. Create in Nextcloud
vim ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/[new-scheme].micro

# 2. Copy to device
cp ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/[new-scheme].micro ~/.config/micro/colorschemes/

# 3. Update settings.json with new colorscheme name
# Change: "colorscheme": "[new-scheme]"
```

**Create sync alias (optional):**

Add to shell profile for one-command sync:

```bash
# macOS/Linux (~/.zshrc or ~/.bashrc)
alias sync-micro='cp ~/nextcloud/Mneme/var/dotfiles/micro/settings.json ~/.config/micro/ && cp -r ~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/* ~/.config/micro/colorschemes/ && echo "✓ Micro config synced"'

# Windows PowerShell ($PROFILE)
function Sync-Micro {
  Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\micro\settings.json" -Destination "$env:APPDATA\micro\" -Force
  Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\micro\colorschemes\*" -Destination "$env:APPDATA\micro\colorschemes\" -Recurse -Force
  Write-Host "✓ Micro config synced" -ForegroundColor Green
}
```

Then: `sync-micro` or `Sync-Micro`

---

## Module 3: Starship Prompt

### Overview

Modern, minimal shell prompt with TokyoNight colorscheme and Cascadia Mono/Code NF (Nerd Font) support. Each OS has its own configuration to account for font/directory differences.

**Files:**
- Source: `~/nextcloud/Mneme/var/dotfiles/starship/` (Nextcloud)
  - `starship-linux.toml` – Linux config (OS symbol included)
  - `starship-macos.toml` – macOS config (no OS symbol, additional modules)
  - `starship-windows.toml` – Windows config (to be populated)
- Fonts: `~/nextcloud/Mneme/var/dotfiles/fonts/cascadia-nerd-fonts/`
- Target: Device starship config directory (OS-specific)

**Key differences:**
- **macOS:** No OS symbol; includes bun, php modules; directory substitutions
- **Linux:** Includes OS symbol; simpler module set
- **Windows:** [TBD]

---

### Setup: Starship Prompt

#### Step 1: Install Starship

##### macOS

```bash
# Install via homebrew
brew install starship

# Verify
starship --version
```

##### Linux

```bash
# Install via package manager (Ubuntu/Debian)
sudo apt install starship
# or Fedora/RHEL:
sudo dnf install starship

# Verify
starship --version
```

##### Windows (PowerShell)

```powershell
# Install via scoop or winget
scoop install starship
# or
winget install starship

# Verify
starship --version
```

#### Step 2: Install Cascadia Mono/Code NF Font

##### macOS

```bash
# Copy fonts from Nextcloud to system fonts
cp ~/nextcloud/Mneme/var/dotfiles/fonts/cascadia-nerd-fonts/*.ttf ~/Library/Fonts/

# Verify
ls ~/Library/Fonts/Cascadia*NF*

# Set in Terminal preferences:
# Terminal → Preferences → Profiles → Font → Cascadia Mono NF (or Cascadia Code NF)
```

##### Linux

```bash
# Copy fonts from Nextcloud to system fonts
mkdir -p ~/.local/share/fonts
cp ~/nextcloud/Mneme/var/dotfiles/fonts/cascadia-nerd-fonts/*.ttf ~/.local/share/fonts/

# Refresh font cache
fc-cache -fv

# Verify
fc-list | grep -i cascadia

# Set in terminal emulator preferences (varies by terminal)
```

##### Windows (PowerShell)

```powershell
# Copy fonts to Windows Fonts directory
$FontPath = "$env:APPDATA\Microsoft\Windows\Fonts"
Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\fonts\cascadia-nerd-fonts\*.ttf" -Destination "$env:SystemRoot\Fonts\" -Force

# Or manually: Windows Settings → Fonts → "Cascadia" → Install

# Set in Windows Terminal:
# Settings → Defaults → Appearance → Font Face → Cascadia Mono NF
```

#### Step 3: Install Starship Config

##### macOS & Linux

```bash
# Create config directory
mkdir -p ~/.config

# Copy appropriate config (symlink for auto-updates)
# macOS:
ln -s ~/nextcloud/Mneme/var/dotfiles/starship/starship-macos.toml ~/.config/starship.toml
# Linux:
ln -s ~/nextcloud/Mneme/var/dotfiles/starship/starship-linux.toml ~/.config/starship.toml

# Verify
cat ~/.config/starship.toml | head -5
```

##### Windows (PowerShell)

```powershell
# Create config directory (when starship config location is determined)
New-Item -ItemType Directory -Force -Path "$env:APPDATA\starship"

# For now, note where config should go:
# $env:APPDATA\starship.toml
# or
# $env:USERPROFILE\.config\starship.toml
```

#### Step 4: Initialize Starship in Shell

##### macOS & Linux

Add to shell profile (`~/.zshrc` for macOS, `~/.bashrc` for Linux):

```bash
# Initialize starship
eval "$(starship init bash)"  # for bash
# or
eval "$(starship init zsh)"   # for zsh
```

##### Windows (PowerShell)

Add to PowerShell profile (`$PROFILE`):

```powershell
# Initialize starship
Invoke-Expression (&{ (& 'starship' init powershell) -join "`n" })
```

#### Step 5: Reload and Verify

```bash
# Reload shell
source ~/.zshrc  # macOS
source ~/.bashrc  # Linux
. $PROFILE       # Windows

# Verify prompt shows colors and is responsive
```

---

### Workflow: Starship

**Update config:**

```bash
# 1. Edit appropriate config in Nextcloud
vim ~/nextcloud/Mneme/var/dotfiles/starship/starship-macos.toml    # macOS
vim ~/nextcloud/Mneme/var/dotfiles/starship/starship-linux.toml    # Linux

# 2. If using symlink, changes auto-reflect on next shell reload
source ~/.zshrc  # or ~/.bashrc or . $PROFILE

# 3. If using copy, update manually:
cp ~/nextcloud/Mneme/var/dotfiles/starship/starship-macos.toml ~/.config/starship.toml
```

**Add new module/customization:**

```bash
# 1. Edit starship config
vim ~/.config/starship.toml

# 2. Add new section (e.g., [python])
[python]
symbol = "🐍"
style = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

# 3. Update format string to include: $python

# 4. Reload shell to see changes
```

**Create sync alias (optional):**

```bash
# macOS/Linux (~/.zshrc or ~/.bashrc)
alias sync-starship='cp ~/nextcloud/Mneme/var/dotfiles/fonts/cascadia-nerd-fonts/*.ttf ~/.local/share/fonts/ && fc-cache -fv && echo "✓ Starship fonts synced" && cp ~/nextcloud/Mneme/var/dotfiles/starship/starship-linux.toml ~/.config/starship.toml && echo "✓ Starship config synced"'

# Windows PowerShell ($PROFILE)
function Sync-Starship {
  Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\fonts\cascadia-nerd-fonts\*.ttf" -Destination "$env:APPDATA\Microsoft\Windows\Fonts\" -Force
  Copy-Item "$env:NEXTCLOUD_HOME\var\dotfiles\starship\starship-windows.toml" -Destination "$env:APPDATA\starship.toml" -Force
  Write-Host "✓ Starship synced" -ForegroundColor Green
}
```

---

## Module 4: Pi Coding Agent

### Overview

[TODO: Add description of Pi Coding Agent setup and configuration]

### Setup: Pi Coding Agent

[TODO: Configuration files, location, setup steps per OS]

### Workflow: Pi Coding Agent

[TODO: How to update/sync configuration]

---

## Module 5: Claude Code CLI

### Overview

[TODO: Add description of Claude Code CLI setup and configuration]

### Setup: Claude Code CLI

[TODO: Installation, configuration, setup steps per OS]

### Workflow: Claude Code CLI

[TODO: How to update/sync configuration]

---

## Module 6: Claude Desktop

### Overview

[TODO: Add description of Claude Desktop setup and configuration]

### Setup: Claude Desktop

[TODO: Installation, preferences, setup steps per OS]

### Workflow: Claude Desktop

[TODO: How to update/sync configuration]

---

## Module 7: Gemini CLI

### Overview

[TODO: Add description of Gemini CLI setup and configuration]

### Setup: Gemini CLI

[TODO: Installation, configuration, setup steps per OS]

### Workflow: Gemini CLI

[TODO: How to update/sync configuration]

---

## Module 8: Gemini Desktop

### Overview

[TODO: Add description of Gemini Desktop setup and configuration (where available)]

### Setup: Gemini Desktop

[TODO: Installation, preferences, setup steps per OS]

### Workflow: Gemini Desktop

[TODO: How to update/sync configuration]

---

## Module 9: OpenCode

### Overview

[TODO: Add description of OpenCode setup and configuration]

### Setup: OpenCode

[TODO: Installation, configuration, setup steps per OS]

### Workflow: OpenCode

[TODO: How to update/sync configuration]

---

## Module 10: tmux

### Overview

[TODO: Add description of tmux setup and configuration]

**Typical configurations:**
- Session management
- Keybindings
- Color scheme
- Plugins

### Setup: tmux

[TODO: Installation, configuration file location, setup steps per OS]

### Workflow: tmux

[TODO: How to update/sync configuration]

---

## Module 11: llama-cpp / llama-swap

### Overview

Local LLM inference server with API customizations. Configuration varies per model server host machine on the homelab infrastructure.

**Components:**
- **llama-cpp-python** – Python bindings for llama.cpp
- **llama-swap** – Model server/router (if applicable)
- **config.yaml** – Per-host configuration (different for each model server machine)
- **API customizations** – Model parameters, endpoint tuning, resource allocation

**Model server machines (homelab):**
- [Host 1 name/config] – config.yaml for host 1
- [Host 2 name/config] – config.yaml for host 2
- [Additional hosts as needed]

---

### Setup: llama-cpp / llama-swap

#### Step 1: Install llama-cpp-python (Per Host)

[TODO: Installation steps for each host machine in homelab]

```bash
# General pattern:
pip install llama-cpp-python
# or with GPU support (CUDA/ROCm):
pip install llama-cpp-python[cuda]
```

#### Step 2: Create Configuration Directory

##### Linux/macOS (Homelab Hosts)

```bash
# On each model server host
mkdir -p /opt/llama-cpp/config
# or
mkdir -p ~/.config/llama-cpp
```

#### Step 3: Install Per-Host Configurations

Configuration files are stored in Nextcloud with per-host naming:

```
~/nextcloud/Mneme/var/dotfiles/llama-cpp/
├── config-[hostname-1].yaml
├── config-[hostname-2].yaml
├── config-[hostname-3].yaml
└── [additional host configs]
```

Copy appropriate config to each host:

```bash
# On each model server host
cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-$(hostname).yaml /opt/llama-cpp/config/config.yaml
# or
cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-$(hostname).yaml ~/.config/llama-cpp/config.yaml
```

#### Step 4: Verify API Configuration

```bash
# Test llama-cpp server start with config
python -m llama_cpp.server --config-file /opt/llama-cpp/config/config.yaml

# Should show:
# - Model loading
# - API endpoint available (typically http://localhost:8000)
# - Configured parameters from config.yaml
```

---

### Workflow: llama-cpp / llama-swap

**Update configuration for a specific host:**

```bash
# 1. Edit config on host machine or in Nextcloud
vim ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[hostname].yaml

# 2. Nextcloud syncs to Atlas
# (Files synced across all devices that have homelab access)

# 3. On target model server host, pull updated config
# (Manual pull or auto-sync depending on setup)
cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[hostname].yaml /opt/llama-cpp/config/config.yaml

# 4. Restart llama-cpp service on that host to load new config
sudo systemctl restart llama-cpp  # if running as service
# or restart the server process manually
```

**Common customizations per host:**

```yaml
# config-[hostname].yaml

# Model selection
model: "/path/to/model.gguf"

# Resource allocation (varies per host hardware)
n_gpu_layers: 50  # GPU layer offloading
n_threads: 16     # CPU threads (host-dependent)
n_batch: 512      # Batch size

# API parameters
api_port: 8000
api_host: "0.0.0.0"  # Or specific interface

# Quantization/inference settings
context_size: 4096
temperature: 0.7

# [Additional host-specific parameters]
```

**Create new host configuration:**

```bash
# 1. Copy template or existing host config
cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[existing-host].yaml ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[new-host].yaml

# 2. Edit for new host's hardware
vim ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[new-host].yaml

# 3. Deploy to new host
cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[new-host].yaml /opt/llama-cpp/config/config.yaml
```

**Create sync alias for homelab hosts (optional):**

```bash
# Add to ~/.bashrc on each model server host
alias sync-llama-cpp='cp ~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-$(hostname).yaml /opt/llama-cpp/config/config.yaml && echo "✓ llama-cpp config synced"'
```

---

## Module [Other]: Applications & Customizations

### Placeholder for Future Modules

Add new modules as needed:

- **shell configuration** – Aliases, functions, prompt customization
- **dotfiles** – Git settings, terminal configs, etc.
- **[Other applications]** – As they're added

**Module template:**
```markdown
## Module [N]: [Application Name]

### Overview
[Brief description]

### Setup: [Application Name]

#### Step 1: [Task]
[Instructions]

#### Step 2: [Task]
[Instructions]

### Workflow: [Application Name]
[How to update/sync]
```

---

## General Troubleshooting

### Environment Variable Issues

**Variable not set:**
```bash
# Check if exported (not just set)
echo $SEED_FILE  # macOS/Linux
echo $env:SEED_FILE  # Windows

# Reload profile if empty
source ~/.bashrc  # Linux
source ~/.zshrc   # macOS
. $PROFILE        # Windows PowerShell

# Verify export line exists
grep SEED_FILE ~/.bashrc     # Linux
grep SEED_FILE ~/.zshrc      # macOS
Get-Content $PROFILE | Select-String SEED_FILE  # Windows
```

### Nextcloud Sync Issues

```bash
# Check sync status
# Open Nextcloud client → Verify "Fully synced"

# If stuck:
# 1. Check network connectivity
# 2. Restart Nextcloud client
# 3. Wait 30+ seconds and retry
```

### Parser/Script Issues

```bash
# Check if parser is in PATH
which seed-parser  # macOS/Linux
Get-Command seed-parser  # Windows

# Check permissions
ls -lh ~/.local/bin/seed-parser  # macOS/Linux

# If missing, reinstall (see Module 1, Step 1)
```

### Generated Files Empty

```bash
# Check source SEED.md is readable
ls -lh $SEED_FILE

# Run parser with verbose output
VERBOSE=1 seed-parser

# Check file permissions on all generated files
ls -lh ~/.claude/claude.md ~/.pi/agent/AGENTS.md
```

---

## Clean OS Wipe Recovery

Use this checklist when setting up a fresh device:

### Pre-Setup Checklist
- [ ] Nextcloud client installed and synced
- [ ] Shell profile exists (`~/.zshrc`, `~/.bashrc`, `$PROFILE`)
- [ ] Network connectivity verified

### Core Setup (All Modules)
- [ ] Environment variables set in shell profile (all modules)
- [ ] Local directories created (`~/.local/bin`, `~/.config`, etc.)
- [ ] Shell profile reloaded (`source` or new terminal)

### Module: Seed System
- [ ] Parser script installed to `~/.local/bin/`
- [ ] Sync alias created in shell profile
- [ ] First run: `sync-seeds` / `Sync-Seeds`
- [ ] Generated files verified (Claude Code, Pi, OpenCode, Gemini)

### Module: Micro Editor
- [ ] Micro editor installed (`brew install micro`, `apt install micro`, `scoop install micro`)
- [ ] Config directory created (`~/.config/micro/colorschemes`)
- [ ] Settings and colorscheme files copied/symlinked from Nextcloud
- [ ] Micro opened and verified (colorscheme loaded correctly)

### Module: Starship Prompt
- [ ] Starship installed (`brew install starship`, `apt install starship`, `winget install starship`)
- [ ] Cascadia Mono/Code NF fonts copied to system font directory
  - macOS: `~/Library/Fonts/`
  - Linux: `~/.local/share/fonts/` + `fc-cache -fv`
  - Windows: `$env:SystemRoot\Fonts\`
- [ ] Font set in terminal application preferences
- [ ] Starship config copied/symlinked (OS-appropriate version)
- [ ] Starship initialized in shell profile (eval statement)
- [ ] Shell reloaded and prompt verified (colors, responsive)

### Module: Pi Coding Agent [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: Claude Code CLI [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: Claude Desktop [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: Gemini CLI [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: Gemini Desktop [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: OpenCode [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: tmux [TODO]
- [ ] [Setup steps TBD]
- [ ] [Verification TBD]

### Module: llama-cpp / llama-swap
- [ ] llama-cpp-python installed on model server host(s)
- [ ] Config directory created (`/opt/llama-cpp/config/` or `~/.config/llama-cpp/`)
- [ ] Per-host config file copied from Nextcloud (config-[hostname].yaml)
- [ ] llama-cpp server started and API responding
- [ ] Model loaded and inference working

### Module: [Other Module]
- [ ] [Setup steps]
- [ ] [Verification]

### Post-Setup
- [ ] All environment variables verified (`echo $SEED_FILE`, `echo $MICRO_DOTFILES`, etc.)
- [ ] All aliases/functions available (`alias -p`, `Get-Command`)
- [ ] All applications/tools verified (micro, agents, etc.)
- [ ] Nextcloud sync fully complete

---

## Quick Reference

### Environment Variables

| Variable | macOS | Linux | Windows |
|----------|-------|-------|---------|
| `NEXTCLOUD_HOME` | `$HOME/Nextcloud/Mneme` | `$HOME/nextcloud/Mneme` | `$env:USERPROFILE\nextcloud\Mneme` |
| `SEED_FILE` | `$NEXTCLOUD_HOME/var/SEED.md` | `$NEXTCLOUD_HOME/var/SEED.md` | `$env:NEXTCLOUD_HOME\var\SEED.md` |

### Common Commands

| Task | macOS/Linux | Windows |
|------|---|---|
| **Edit SEED.md** | `vim ~/nextcloud/Mneme/var/SEED.md` | `notepad $env:SEED_FILE` |
| **Edit micro settings** | `vim ~/nextcloud/Mneme/var/dotfiles/micro/settings.json` | `notepad $env:MICRO_DOTFILES\settings.json` |
| **Edit starship config** | `vim ~/.config/starship.toml` | `notepad $env:APPDATA\starship.toml` |
| **Sync seeds** | `sync-seeds` | `Sync-Seeds` |
| **Sync micro** | `sync-micro` | `Sync-Micro` |
| **Sync starship** | `sync-starship` | `Sync-Starship` |
| **Open micro** | `micro` | `micro` |
| **Check starship** | `starship config` | `starship config` |
| **Check fonts** | `fc-list \| grep Cascadia` | `Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" \| Select-String Cascadia` |
| **Check env vars** | `env \| grep SEED` | `Get-Variable SEED*` |
| **View agent config** | `cat ~/.claude/claude.md` | `Get-Content ~\.claude\claude.md` |
| **View micro config** | `cat ~/.config/micro/settings.json` | `Get-Content $env:APPDATA\micro\settings.json` |
| **View starship config** | `cat ~/.config/starship.toml` | `Get-Content $env:APPDATA\starship.toml` |
| **List aliases** | `alias` | `Get-Alias` |
| **Reload profile** | `source ~/.zshrc` | `. $PROFILE` |

### File Locations

**Source (Nextcloud):**
- `~/nextcloud/Mneme/var/SEED.md`
- `~/nextcloud/Mneme/var/seed-parser.sh`
- `~/nextcloud/Mneme/var/dotfiles/micro/settings.json`
- `~/nextcloud/Mneme/var/dotfiles/micro/colorschemes/tokyonight.micro`
- `~/nextcloud/Mneme/var/dotfiles/starship/starship-linux.toml`
- `~/nextcloud/Mneme/var/dotfiles/starship/starship-macos.toml`
- `~/nextcloud/Mneme/var/dotfiles/starship/starship-windows.toml`
- `~/nextcloud/Mneme/var/dotfiles/fonts/cascadia-nerd-fonts/*.ttf`

**Generated/Synced (Local):**

*Seed System:*
- `~/.claude/claude.md`
- `~/.pi/agent/AGENTS.md`
- `~/.gemini/settings.json`
- `~/.config/opencode/opencode.json`

*Micro Editor:*
- `~/.config/micro/settings.json` (macOS/Linux)
- `~/.config/micro/colorschemes/tokyonight.micro` (macOS/Linux)
- `$env:APPDATA\micro\settings.json` (Windows)
- `$env:APPDATA\micro\colorschemes\tokyonight.micro` (Windows)

*Starship Prompt:*
- `~/.config/starship.toml` (macOS/Linux)
- `$env:APPDATA\starship.toml` or `$env:USERPROFILE\.config\starship.toml` (Windows)

*Cascadia Mono/Code NF Fonts:*
- `~/Library/Fonts/Cascadia*NF*.ttf` (macOS)
- `~/.local/share/fonts/Cascadia*NF*.ttf` (Linux)
- `$env:SystemRoot\Fonts\Cascadia*NF*.ttf` (Windows)

*llama-cpp / llama-swap:*
- `~/nextcloud/Mneme/var/dotfiles/llama-cpp/config-[hostname].yaml` (Source on Nextcloud)
- `/opt/llama-cpp/config/config.yaml` (Deployed on model server host)
- `~/.config/llama-cpp/config.yaml` (Alternative location on model server host)

---

## Support & Maintenance

### Adding a New Module

1. Create source files in `~/nextcloud/Mneme/var/[module-name]/`
2. Create parser/sync script if needed
3. Add environment variables to core setup section
4. Document setup steps using module template
5. Add to clean wipe recovery checklist

### Updating Documentation

- Keep environment variables section in sync with all modules
- Update quick reference when adding commands
- Update clean wipe checklist when adding modules

---

*Last verified: May 13, 2026*  
*Compatible with: macOS, Linux, Windows + Nextcloud client*  
*Modules: Seed System + [Extensible]*
