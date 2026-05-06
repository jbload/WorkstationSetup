#!/bin/sh

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
case "$repo_root" in
    "$HOME"/*)
        repo_home="~/${repo_root#"$HOME"/}"
        ;;
    *)
        repo_home=$repo_root
        ;;
esac

check_file_contains() {
    file=$1
    needle=$2
    label=$3
    instructions=$4
    alternate_needle=${5:-}

    if [ ! -f "$file" ]; then
        printf 'MISSING  %s\n' "$label"
        printf '         %s does not exist.\n' "$file"
        printf '         %b\n\n' "$instructions"
        return
    fi

    if grep -F "$needle" "$file" > /dev/null 2>&1 ||
        { [ -n "$alternate_needle" ] && grep -F "$alternate_needle" "$file" > /dev/null 2>&1; }; then
        printf 'OK       %s\n' "$label"
    else
        printf 'MISSING  %s\n' "$label"
        printf '         Add this to %s:\n' "$file"
        printf '         %b\n' "$instructions"
    fi

    printf '\n'
}

check_optional_file() {
    file=$1
    description=$2

    if [ -e "$file" ]; then
        printf 'EXISTS   %s\n' "$file"
    else
        printf 'ABSENT   %s\n' "$file"
    fi

    printf '         %s\n\n' "$description"
}

printf 'Entrypoint wiring\n'
printf '=================\n\n'

check_file_contains \
    "$HOME/.gitconfig" \
    "$repo_root/git-config/gitconfig.shared" \
    "~/.gitconfig includes shared Git config" \
    "[include]\n    path = $repo_home/git-config/gitconfig.shared" \
    "$repo_home/git-config/gitconfig.shared"

case "$(uname -s)" in
    Darwin)
        platform_gitconfig="$repo_root/git-config/gitconfig.macos"
        platform_gitconfig_home="$repo_home/git-config/gitconfig.macos"
        ;;
    Linux)
        platform_gitconfig="$repo_root/git-config/gitconfig.linux"
        platform_gitconfig_home="$repo_home/git-config/gitconfig.linux"
        ;;
    *)
        platform_gitconfig="$repo_root/git-config/gitconfig.windows"
        platform_gitconfig_home="$repo_home/git-config/gitconfig.windows"
        ;;
esac

check_file_contains \
    "$HOME/.gitconfig" \
    "$platform_gitconfig" \
    "~/.gitconfig includes platform Git config" \
    "[include]\n    path = $platform_gitconfig_home" \
    "$platform_gitconfig_home"

check_file_contains \
    "$HOME/.gitconfig" \
    "$HOME/.gitconfig.local-machine" \
    "~/.gitconfig includes local-machine Git config" \
    "[include]\n    path = ~/.gitconfig.local-machine" \
    "~/.gitconfig.local-machine"

check_file_contains \
    "$HOME/.zshrc" \
    "$repo_root/terminal-settings/zshrc.shared.sh" \
    "~/.zshrc sources shared zsh config" \
    "source $repo_home/terminal-settings/zshrc.shared.sh" \
    "$repo_home/terminal-settings/zshrc.shared.sh"

check_file_contains \
    "$HOME/.bashrc" \
    "$repo_root/terminal-settings/bashrc.shared.sh" \
    "~/.bashrc sources shared bash config" \
    "source $repo_home/terminal-settings/bashrc.shared.sh" \
    "$repo_home/terminal-settings/bashrc.shared.sh"

powershell_profile="$HOME/.config/powershell/profile.ps1"
check_file_contains \
    "$powershell_profile" \
    "$repo_root/terminal-settings/pwshrc.shared.ps1" \
    "PowerShell profile dot-sources shared config" \
    ". \"$repo_home/terminal-settings/pwshrc.shared.ps1\"" \
    "$repo_home/terminal-settings/pwshrc.shared.ps1"

printf 'Optional local-machine files\n'
printf '============================\n\n'

check_optional_file "$HOME/.gitconfig.local-machine" "Git settings that differ on this machine, such as maintenance.repo entries or work-only overrides."
check_optional_file "$HOME/.gitignore" "Global ignore patterns for junk you never want to commit on this machine."
check_optional_file "$HOME/.zshrc.local-machine-config" "Zsh values consumed by the shared config, such as WORKSPACE, GIT_REPOS, or startup flags."
check_optional_file "$HOME/.zshrc.local-machine-overrides" "Zsh aliases, functions, PATH changes, or environment values that should override shared config."
check_optional_file "$HOME/.bashrc.local-machine-config" "Bash values consumed by the shared config, such as WORKSPACE, GIT_REPOS, or startup flags."
check_optional_file "$HOME/.bashrc.local-machine-overrides" "Bash aliases, functions, PATH changes, or environment values that should override shared config."
check_optional_file "$HOME/.pwshrc.local-machine-config.ps1" "PowerShell values consumed by the shared config, such as workspace, tool toggles, or repo lists."
check_optional_file "$HOME/.pwshrc.local-machine-overrides.ps1" "PowerShell functions, aliases, modules, or variables that should override shared config."
