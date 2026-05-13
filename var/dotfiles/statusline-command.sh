#!/usr/bin/env bash
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

[ -z "$cwd" ] && cwd=$(pwd)

user_host=$(printf '\033[01;32m%s@%s\033[00m' "$(whoami)" "$(hostname -s)")
dir_part=$(printf '\033[01;34m%s\033[00m' "$cwd")

model_part=""
[ -n "$model" ] && model_part=$(printf ' \033[0;36m[%s]\033[00m' "$model")

ctx_part=""
if [ -n "$used_pct" ]; then
  ctx_pct=$(printf '%.0f' "$used_pct")
  ctx_part=$(printf ' \033[0;33mctx:%s%%\033[00m' "$ctx_pct")
fi

printf '%s:%s%s%s' "$user_host" "$dir_part" "$model_part" "$ctx_part"
