#!/bin/bash

humanize() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "null" ]; then
    echo ""
    return
  fi
  if [ "$n" -ge 1000000 ] 2>/dev/null; then
    printf "%.1fM" "$(echo "scale=4; $n / 1000000" | bc)"
  elif [ "$n" -ge 1000 ] 2>/dev/null; then
    printf "%.1fk" "$(echo "scale=4; $n / 1000" | bc)"
  else
    echo "$n"
  fi
}

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context usage (pre-calculated by Claude Code)
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_total=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Turn metrics (from current API call)
turn_in=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
turn_out=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // empty')

# Rate limits
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# --- Prompt line: user@host:cwd ---
printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$(whoami)" "$(hostname -s)" "$cwd"

# --- Model name ---
if [ -n "$model" ]; then
  printf ' \033[00;35m| Model: %s\033[00m' "$model"
fi

# --- Turn stats ---
if [ -n "$turn_in" ]; then
  printf ' \033[00;33m| Turn: in=%s out=%s\033[00m' "$(humanize "$turn_in")" "$(humanize "$turn_out")"
fi

# --- Context usage (simplified) ---
if [ -n "$ctx_pct" ]; then
  if [ -n "$ctx_total" ] && [ -n "$ctx_size" ]; then
    printf ' \033[00;36m| Ctx: %.0f%% (%s/%s)\033[00m' "$ctx_pct" "$(humanize "$ctx_total")" "$(humanize "$ctx_size")"
  else
    printf ' \033[00;36m| Ctx: %.0f%%\033[00m' "$ctx_pct"
  fi
fi

# --- Rate limits ---
limits=""
if [ -n "$five_h" ]; then
  limits="5h=$(printf '%.0f' "$five_h")%"
fi
if [ -n "$seven_d" ]; then
  [ -n "$limits" ] && limits="$limits "
  limits="${limits}7d=$(printf '%.0f' "$seven_d")%"
fi
if [ -n "$limits" ]; then
  printf ' \033[00;36m| %s\033[00m' "$limits"
fi

printf '\033[00m'
