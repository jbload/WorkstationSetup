# claude-iterm2.zsh - iTerm2 integration for Claude Code
# https://github.com/anthropics/claude-code
#
# Features:
#   - Unique tab colors per directory (great for multiple repo clones)
#   - Optional custom tab icon via iTerm2 profile
#   - Automatic color/icon reset when Claude exits
#
# Installation:
#   1. Copy this file to ~/.claude/claude-iterm2.zsh
#   2. Add to your .zshrc: source ~/.claude/claude-iterm2.zsh
#
# Configuration (optional, set before sourcing):
#   CLAUDE_ITERM_PROFILE      - iTerm2 profile name with custom icon (enables icon feature)
#   CLAUDE_ITERM_ORIGINAL_PROFILE - Profile to restore on exit (default: "Default")
#   CLAUDE_BIN                - Path to claude binary (default: auto-detect)
#
# Custom Icon Setup:
#   1. Download icon: curl -o ~/.claude/claude-icon.png "https://code.claude.com/docs/_mintlify/favicons/claude-code/pLsy-mRpNksna2sx/_generated/favicon-dark/favicon-32x32.png"
#   2. Create iTerm2 profile: Preferences → Profiles → "+" → name it "Claude"
#   3. Set icon: General → Icon → Custom → select ~/.claude/claude-icon.png
#   4. Add to .zshrc before sourcing: export CLAUDE_ITERM_PROFILE="Claude"

# Guard against double-sourcing
[[ -n "$_CLAUDE_ITERM2_LOADED" ]] && return
_CLAUDE_ITERM2_LOADED=1

# --- Color Generation --------------------------------------------------------

# Generate stable H, S, L values from directory name
# Uses salted hashes for independent color components
# Trailing numbers (e.g., repo2, repo3) get golden angle hue shifts
_claude_iterm2_hsl_from_string() {
  local s="$1" md_h md_s md_l
  local base_name="$s" trailing_num=0

  # Extract trailing number (e.g., "work-backend2" -> "work-backend", 2)
  if [[ "$s" =~ ^(.*[^0-9])([0-9]+)$ ]]; then
    base_name="${match[1]}"
    trailing_num="${match[2]}"
  fi

  # Hash the base name (without trailing number) using different salts
  if command -v md5 >/dev/null 2>&1; then
    md_h=$(printf "hue:%s" "$base_name" | md5)
    md_s=$(printf "sat:%s" "$base_name" | md5)
    md_l=$(printf "lit:%s" "$base_name" | md5)
  else
    md_h=$(printf "hue:%s" "$base_name" | shasum -a 256 | awk '{print $1}')
    md_s=$(printf "sat:%s" "$base_name" | shasum -a 256 | awk '{print $1}')
    md_l=$(printf "lit:%s" "$base_name" | shasum -a 256 | awk '{print $1}')
  fi

  local dec_h=$(( 16#${md_h:0:8} ))
  local dec_s=$(( 16#${md_s:0:8} ))
  local dec_l=$(( 16#${md_l:0:8} ))

  local hue=$(( dec_h % 360 ))

  # Shift hue by golden angle (137°) for numbered variants
  # Guarantees maximum visual separation
  if (( trailing_num > 0 )); then
    hue=$(( (hue + trailing_num * 137) % 360 ))
  fi

  local -F sat=$(( 0.45 + (dec_s % 1000) / 2500.0 ))
  local -F lit=$(( 0.35 + (dec_l % 1000) / 5000.0 ))

  printf "%.0f %.3f %.3f\n" "$hue" "$sat" "$lit"
}

# HSL to RGB conversion (zsh floating point math)
_claude_iterm2_hsl_to_rgb() {
  local -F h="$1" s="$2" l="$3" q p
  h=$(( h/360.0 ))

  if (( s == 0 )); then
    printf "%d %d %d\n" $((l*255)) $((l*255)) $((l*255))
    return
  fi

  if (( l < 0.5 )); then
    q=$(( l*(1+s) ))
  else
    q=$(( l + s - l*s ))
  fi
  p=$(( 2*l - q ))

  _claude_hue2rgb() {
    local -F p="$1" q="$2" t="$3"
    while (( t < 0 )); do t=$(( t+1 )); done
    while (( t > 1 )); do t=$(( t-1 )); done
    if (( t < 1.0/6 )); then
      echo $(( p + (q-p)*6*t ))
    elif (( t < 1.0/2 )); then
      echo $(( q ))
    elif (( t < 2.0/3 )); then
      echo $(( p + (q-p)*(2.0/3 - t)*6 ))
    else
      echo $(( p ))
    fi
  }

  local -F r g b
  r=$(_claude_hue2rgb $p $q $(( h + 1.0/3 )))
  g=$(_claude_hue2rgb $p $q $h)
  b=$(_claude_hue2rgb $p $q $(( h - 1.0/3 )))

  printf "%d %d %d\n" $((r*255)) $((g*255)) $((b*255))
}

# Compute perceived luma for contrast calculation
_claude_iterm2_luma() {
  local -F r="$1" g="$2" b="$3"
  echo $(( 0.2126*r + 0.7152*g + 0.0722*b ))
}

# --- iTerm2 Escape Sequences -------------------------------------------------

_claude_iterm2_apply_tab_rgb() {
  local r="$1" g="$2" b="$3" fg="${4:--1}"

  # Set background color
  printf '\e]6;1;bg;red;brightness;%d\a'   "$r"
  printf '\e]6;1;bg;green;brightness;%d\a' "$g"
  printf '\e]6;1;bg;blue;brightness;%d\a'  "$b"

  # Auto-select foreground for contrast
  if [[ "$fg" == "-1" ]]; then
    local -F L; L=$(_claude_iterm2_luma "$r" "$g" "$b")
    if (( L < 140 )); then fg=255; else fg=0; fi
  fi

  printf '\e]6;1;fg;red;brightness;%d\a'   "$fg"
  printf '\e]6;1;fg;green;brightness;%d\a' "$fg"
  printf '\e]6;1;fg;blue;brightness;%d\a'  "$fg"
}

_claude_iterm2_reset_tab_colors() {
  printf '\e]6;1;bg;*;default\a'
  printf '\e]6;1;fg;*;default\a'
}

_claude_iterm2_set_profile() {
  [[ -n "$1" ]] && printf '\e]1337;SetProfile=%s\a' "$1"
}

# --- Public Functions --------------------------------------------------------

# Set tab color based on directory name
claude_set_tab_color() {
  local dir_name="${1:-$(basename "$PWD")}"
  local hue sat lit r g b

  read hue sat lit < <(_claude_iterm2_hsl_from_string "$dir_name")
  read r g b < <(_claude_iterm2_hsl_to_rgb "$hue" "$sat" "$lit")
  _claude_iterm2_apply_tab_rgb "$r" "$g" "$b" -1
}

# --- Claude Wrapper ----------------------------------------------------------

# Capture existing alias if present
zmodload -F zsh/parameter p:aliases 2>/dev/null
typeset -g _claude_orig_alias
if [[ -n ${aliases[claude]} ]]; then
  _claude_orig_alias=${aliases[claude]}
  unalias claude
fi

# Find claude binary
_claude_find_bin() {
  if [[ -n "$CLAUDE_BIN" ]]; then
    echo "$CLAUDE_BIN"
  elif [[ -x /opt/homebrew/bin/claude ]]; then
    echo "/opt/homebrew/bin/claude"
  elif [[ -x /usr/local/bin/claude ]]; then
    echo "/usr/local/bin/claude"
  else
    whence -p claude 2>/dev/null || echo "claude"
  fi
}

function claude {
  local dir_name
  dir_name=$(basename "$PWD")

  # Switch to Claude profile (for custom icon) if configured
  [[ -n "$CLAUDE_ITERM_PROFILE" ]] && _claude_iterm2_set_profile "$CLAUDE_ITERM_PROFILE"

  # Set tab color based on directory
  claude_set_tab_color "$dir_name"

  # Run claude
  if [[ -n $_claude_orig_alias ]]; then
    eval "$_claude_orig_alias ${(q)@}"
  else
    command "$(_claude_find_bin)" "$@"
  fi

  # Reset on exit
  _claude_iterm2_reset_tab_colors
  [[ -n "$CLAUDE_ITERM_PROFILE" ]] && _claude_iterm2_set_profile "${CLAUDE_ITERM_ORIGINAL_PROFILE:-Default}"
}