#!/bin/bash

# seed-parser.sh - Multi-agent seed file parser
# Reads SEED.md from $SEED_FILE, extracts agent-specific sections,
# generates configuration files for Claude Code, Pi, OpenCode, Gemini

set -e

VERSION="1.0"
VERBOSE=${VERBOSE:-0}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# Utility Functions
# ============================================================================

log() {
  echo -e "${GREEN}[seed-parser]${NC} $*"
}

warn() {
  echo -e "${YELLOW}[warning]${NC} $*" >&2
}

error() {
  echo -e "${RED}[error]${NC} $*" >&2
}

debug() {
  if [ "$VERBOSE" = "1" ]; then
    echo -e "${YELLOW}[debug]${NC} $*" >&2
  fi
}

# ============================================================================
# Check Requirements
# ============================================================================

check_seed_file() {
  if [ -z "$SEED_FILE" ]; then
    error "SEED_FILE environment variable not set"
    error "Set it in your shell profile (~/.bashrc, ~/.zshrc, or PowerShell \$PROFILE)"
    return 1
  fi

  if [ ! -f "$SEED_FILE" ]; then
    error "SEED_FILE does not exist: $SEED_FILE"
    return 1
  fi

  debug "SEED_FILE: $SEED_FILE"
  return 0
}

# ============================================================================
# Section Extraction
# ============================================================================

extract_section() {
  local agent="$1"
  local seed_file="$2"

  # Extract content between <!-- @agent-name --> and <!-- @end -->
  awk "/<!-- @${agent} -->/,/<!-- @end -->/" "$seed_file" | \
    sed '/<!-- @'"${agent}"' -->/d' | \
    sed '/<!-- @end -->/d'
}

# ============================================================================
# Agent Generators
# ============================================================================

generate_claude_code() {
  local seed_file="$1"
  local output_file="${HOME}/.claude/claude.md"

  log "Generating Claude Code configuration..."

  # Create directory if needed
  mkdir -p "$(dirname "$output_file")"

  # Extract universal sections + Claude-specific section
  {
    # Extract Sections I-XIV (universal)
    sed '/<!-- @claude-code -->/,/<!-- @custom -->/d' "$seed_file"

    # Extract Claude-specific section (without markers)
    extract_section "claude-code" "$seed_file"
  } > "$output_file"

  if [ -s "$output_file" ]; then
    log "✓ Claude Code: $output_file"
    return 0
  else
    error "Failed to generate Claude Code configuration"
    return 1
  fi
}

generate_pi_agent() {
  local seed_file="$1"
  local output_file="${HOME}/.pi/agent/AGENTS.md"

  log "Generating Pi Agent configuration..."

  # Create directory if needed
  mkdir -p "$(dirname "$output_file")"

  # Extract universal + Pi-specific sections
  {
    # Header
    echo "# Pi Coding Agent Configuration"
    echo ""

    # Sections II (Expertise), IV (Standards), IX (Productivity), XII (Summary)
    echo "## Expertise & Approach"
    sed -n '/^## II\. Expertise/,/^## III\. Active Projects/p' "$seed_file" | sed '$d'
    echo ""

    echo "## Engineering Standards"
    sed -n '/^## IV\. Engineering Standards/,/^## V\. Technology/p' "$seed_file" | sed '$d'
    echo ""

    echo "## Productivity & Workflow"
    sed -n '/^## IX\. Productivity/,/^## X\. Community/p' "$seed_file" | sed '$d'
    echo ""

    # Extract Pi-specific section
    extract_section "pi-agent" "$seed_file"
  } > "$output_file"

  if [ -s "$output_file" ]; then
    log "✓ Pi Agent: $output_file"
    return 0
  else
    error "Failed to generate Pi Agent configuration"
    return 1
  fi
}

generate_opencode() {
  local seed_file="$1"
  local output_file="${HOME}/.config/opencode/opencode.json"

  log "Generating OpenCode configuration..."

  # Create directory if needed
  mkdir -p "$(dirname "$output_file")"

  # Generate JSON config
  {
    cat <<'EOF'
{
  "agents": {
    "bobby": {
      "description": "Bobby's technical profile and working style",
      "instructions": "See ~/.pi/agent/AGENTS.md for full profile. Key principles: clarity > cleverness, pragmatism > formalism, empiricism > assumption."
    }
  },
  "settings": {
    "defaultAgent": "bobby",
    "autoSave": true,
    "errorHandling": "soft-yelling",
    "validation": "task-dependent"
  },
  "paths": {
    "seedFile": "OPENCODE_SEED_FILE_ENV_VAR_NOT_SET",
    "localOverrides": "./.opencode/agents/"
  }
}
EOF
  } > "$output_file"

  if [ -s "$output_file" ]; then
    log "✓ OpenCode: $output_file"
    return 0
  else
    error "Failed to generate OpenCode configuration"
    return 1
  fi
}

generate_gemini() {
  local seed_file="$1"
  local output_file="${HOME}/.gemini/settings.json"

  log "Generating Gemini CLI configuration..."

  # Create directory if needed
  mkdir -p "$(dirname "$output_file")"

  # Generate JSON config
  {
    cat <<'EOF'
{
  "model": {
    "provider": "google",
    "name": "gemini-2.0-flash"
  },
  "style": {
    "responseLength": "adaptive",
    "tone": "casual",
    "includeSummary": false
  },
  "tools": {
    "autoAllow": ["read", "bash", "grep", "find"],
    "confirmationRequired": ["write", "delete", "push"]
  },
  "decisionThreshold": 0.8,
  "documentation": "Full Bobby profile at ~/.pi/agent/AGENTS.md"
}
EOF
  } > "$output_file"

  if [ -s "$output_file" ]; then
    log "✓ Gemini: $output_file"
    return 0
  else
    error "Failed to generate Gemini configuration"
    return 1
  fi
}

# ============================================================================
# Main
# ============================================================================

usage() {
  cat <<EOF
Usage: seed-parser [OPTIONS]

Generate agent-specific configuration files from centralized SEED.md

OPTIONS:
  --agent AGENT      Generate config for specific agent only (claude, pi, opencode, gemini)
  --verbose          Show debug output
  --help             Show this help message
  --version          Show version

ENVIRONMENT VARIABLES:
  SEED_FILE          Path to SEED.md (required)
                     Set in ~/.bashrc, ~/.zshrc, or PowerShell \$PROFILE

AGENTS SUPPORTED:
  claude             Claude Code agent
  pi                 Pi Coding Agent
  opencode           OpenCode agent
  gemini             Gemini CLI agent
  all                All agents (default)

EXAMPLES:
  seed-parser                    # Generate all agent configs
  seed-parser --agent claude     # Generate Claude Code config only
  VERBOSE=1 seed-parser          # Run with debug output

EOF
  exit 0
}

main() {
  local target_agent="all"
  local exit_code=0

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agent)
        target_agent="$2"
        shift 2
        ;;
      --verbose)
        VERBOSE=1
        shift
        ;;
      --help)
        usage
        ;;
      --version)
        echo "seed-parser version $VERSION"
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done

  # Validate setup
  if ! check_seed_file; then
    exit 1
  fi

  log "Starting seed parser (v$VERSION)..."
  debug "Target agent(s): $target_agent"

  # Generate requested agents
  case "$target_agent" in
    claude)
      generate_claude_code "$SEED_FILE" || exit_code=$?
      ;;
    pi)
      generate_pi_agent "$SEED_FILE" || exit_code=$?
      ;;
    opencode)
      generate_opencode "$SEED_FILE" || exit_code=$?
      ;;
    gemini)
      generate_gemini "$SEED_FILE" || exit_code=$?
      ;;
    all)
      generate_claude_code "$SEED_FILE" || exit_code=$?
      generate_pi_agent "$SEED_FILE" || exit_code=$?
      generate_opencode "$SEED_FILE" || exit_code=$?
      generate_gemini "$SEED_FILE" || exit_code=$?
      ;;
    *)
      error "Unknown agent: $target_agent"
      exit 1
      ;;
  esac

  if [ $exit_code -eq 0 ]; then
    log "✓ All seeds parsed successfully"
  else
    error "Some seeds failed to parse (exit code: $exit_code)"
  fi

  return $exit_code
}

# Run main if script is executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
