#!/usr/bin/env bash

set -euo pipefail

main() {
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  local shared_file="${script_dir}/AGENTS.md"
  local display_path
  local import_path

  if [[ "$shared_file" == "$HOME"* ]]; then
    display_path="~${shared_file#"$HOME"}"
    import_path="../${shared_file#"$HOME"/}"
  else
    display_path="$shared_file"
    import_path="$shared_file"
  fi

  local selected_agents
  selected_agents="$(resolve_selected_agents "$@")"

  if [ -z "$selected_agents" ]; then
    echo "No agents selected. Exiting."
    return 0
  fi

  while IFS= read -u 3 -r agent; do
    install_agent "$agent" "$script_dir" "$shared_file" "$import_path" "$display_path"
  done 3<<< "$selected_agents"
}

resolve_selected_agents() {
  local -a args=("$@")

  if [ ${#args[@]} -gt 0 ]; then
    local -a resolved=()

    for arg in "${args[@]}"; do

      case "$arg" in
        [aA][lL][lL])
          printf '%s\n' "Claude" "Gemini" "Codex"
          return 0
          ;;
        [cC][lL][aA][uU][dD][eE])
          resolved+=("Claude")
          ;;
        [gG][eE][mM][iI][nN][iI])
          resolved+=("Gemini")
          ;;
        [cC][oO][dD][eE][xX])
          resolved+=("Codex")
          ;;
      esac

    done

    printf '%s\n' "${resolved[@]}"
    return 0
  fi

  if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
    local fzf_output
    fzf_output="$(printf '%s\n' "Claude" "Gemini" "Codex" | fzf --multi --bind 'load:select-all' --prompt="Use ↑ ↓ to move, TAB to toggle selections and ENTER to submit selections: " || true)"

    if [ -n "$fzf_output" ]; then
      printf '%s\n' "$fzf_output"
    fi

    return 0
  fi

  printf '%s\n' "Claude" "Gemini" "Codex"
}

install_agent() {
  local agent="$1"
  local script_dir="$2"
  local shared_file="$3"
  local import_path="$4"
  local display_path="$5"

  case "$agent" in
    Claude)
      install_claude "$script_dir" "$shared_file" "$import_path" "$display_path"
      ;;
    Gemini)
      install_gemini "$shared_file" "$import_path" "$display_path"
      ;;
    Codex)
      install_codex "$shared_file" "$display_path"
      ;;
  esac
}

install_claude() {
  local script_dir="$1"
  local shared_file="$2"
  local import_path="$3"
  local display_path="$4"

  install_claude_assets "$script_dir"
  ensure_imported_rule_file "$HOME/.claude/CLAUDE.md" "$shared_file" "$import_path" "$display_path"
}

install_gemini() {
  local shared_file="$1"
  local import_path="$2"
  local display_path="$3"

  ensure_imported_rule_file "$HOME/.gemini/GEMINI.md" "$shared_file" "$import_path" "$display_path"

  if [ -d "$HOME/.gemini/config" ]; then
    ln -sf "$HOME/.gemini/GEMINI.md" "$HOME/.gemini/config/GEMINI.md"
  fi
}

install_codex() {
  local shared_file="$1"
  local display_path="$2"

  ensure_codex_rule_file "$HOME/.codex/AGENTS.md" "$shared_file" "$display_path"
}

install_claude_assets() {
  local script_dir="$1"

  mkdir -p "$HOME/.claude"

  if [ -t 0 ]; then
    cp -i \
      "${script_dir}/claude/claude-icon.png" \
      "${script_dir}/claude/claude-iterm2.zsh" \
      "${script_dir}/claude/claude-powerline.json" \
      "${script_dir}/claude/settings.json" \
      "$HOME/.claude/" < /dev/tty || true
  else
    cp -i \
      "${script_dir}/claude/claude-icon.png" \
      "${script_dir}/claude/claude-iterm2.zsh" \
      "${script_dir}/claude/claude-powerline.json" \
      "${script_dir}/claude/settings.json" \
      "$HOME/.claude/" < /dev/null || true
  fi

  echo "See comments in tool-settings/agents/claude/claude-iterm2.zsh for follow-up install instructions."
}

ensure_imported_rule_file() {
  local target_file="$1"
  local shared_file="$2"
  local import_path="$3"
  local display_path="$4"
  local file_name
  file_name="$(basename "$target_file")"

  if [ -f "$target_file" ]; then
    local first_line
    first_line="$(head -n 1 "$target_file")"

    if [[ "$first_line" == *"@import"* && ("$first_line" == *"$import_path"* || "$first_line" == *"$shared_file"* || "$first_line" == *"$display_path"*) ]]; then
      echo "Global ${file_name} file has already imported ${display_path}."
    else
      local tmp_file
      tmp_file="$(mktemp)"
      printf '%s\n' "@import ${import_path}" > "$tmp_file"
      cat "$target_file" >> "$tmp_file"
      mv "$tmp_file" "$target_file"

      echo "Added '@import ${import_path}' to the global ${file_name} file."
    fi
  else
    mkdir -p "$(dirname "$target_file")"
    printf '%s\n\n' "@import ${import_path}" > "$target_file"

    echo "Global ${file_name} file does not exist. Creating a new ${file_name} file that imports ${display_path}."
  fi
}

ensure_codex_rule_file() {
  local target_file="$1"
  local shared_file="$2"
  local display_path="$3"
  local file_name
  file_name="$(basename "$target_file")"

  mkdir -p "$(dirname "$target_file")"

  if [ -L "$target_file" ]; then
    local current_target
    current_target="$(readlink "$target_file")"

    if [ "$current_target" = "$shared_file" ]; then
      echo "Global Codex ${file_name} file is already symlinked to ${display_path}."
    else
      cp -P "$target_file" "${target_file}.bak"
      ln -sf "$shared_file" "$target_file"

      echo "Global Codex ${file_name} file has been backed up to ${file_name}.bak and replaced with a symlink to ${display_path}."
    fi
  elif [ -e "$target_file" ]; then
    cp "$target_file" "${target_file}.bak"
    ln -sf "$shared_file" "$target_file"

    echo "Global Codex ${file_name} file has been backed up to ${file_name}.bak and replaced with a symlink to ${display_path}."
  else
    ln -s "$shared_file" "$target_file"

    echo "Global Codex ${file_name} file does not exist. Creating a symlink to ${display_path}."
  fi
}

main "$@"
