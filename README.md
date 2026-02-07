# WorkstationSetup

A repository of configuration and tooling used to set up and standardize a development workstation. Clone this repo and run the included scripts to install tools and apply settings so new machines (or fresh installs) match a consistent environment.

## What's in this repo

| Directory / file | Purpose |
|------------------|--------|
| **tools.sh** | Homebrew-based install script for core CLI tools, languages (Java, Node, Python, .NET), Kubernetes tooling, browsers, media apps, AI tools, and optional extras. Run on macOS after installing [Homebrew](https://brew.sh). While it can be run in its entirety, most likely you'll want to pick and choose the specific tools you need for a particular machine.|
| **git-config/** | Global Git config (`gitconfig`), platform-specific overrides (`gitconfig_custom_mac+linux`, `gitconfig_custom_windows`), and a shared `gitignore`. Copy or symlink into place and merge with any existing `~/.gitconfig`. |
| **terminal-settings/** | Shell configs and terminal profiles: `zshrc`, `bashrc`, `pwshrc` (plus pre/post init hooks), Oh My Posh theme (`.oh-my-posh.justin.json`), and profiles for iTerm2 and Windows Terminal. Use the `install-*.sh` / `install-*.ps1` scripts to deploy to your home directory (with backups). |
| **ps-modules/** | Bundled PowerShell modules: **oh-my-posh**, **posh-git**, and **PSKubectlCompletion**, for use when PowerShell isn’t allowed to install from the gallery or you want fixed versions. |
| **fonts/** | Fonts such as Cascadia Code (also installable via `brew install --cask font-cascadia-code` from `tools.sh`). |
| **tool-settings/** | Exported or backup settings for IDEs and tools: VS Code, Visual Studio, ReSharper, JetBrains, Beyond Compare, Sublime Text, SSMS, and Claude (e.g. iTerm2 theme, powerline config). Import or copy as needed per tool. |
| **Mac Keyboard Shortcuts.docx** | Reference for custom Mac keyboard shortcuts. |

## Quick start

1. **Clone the repo**  
   ```bash
   git clone <repo-url> ~/WorkstationSetup && cd ~/WorkstationSetup
   ```

2. **Install tools (macOS)**  
   Ensure [Homebrew](https://brew.sh) is installed, then:  
   ```bash
   ./tools.sh
   ```  
   Edit `tools.sh` to comment out sections you don’t need (e.g. iOS, Microk8s, music apps) or just copy and paste selected commands into your terminal.

3. **Apply terminal config**  
   From `terminal-settings/`:  
   - **Zsh:** `./install-zshrc.sh`  
   - **Bash:** `./install-bashrc.sh`  
   - **PowerShell:** `./install-pwshrc.ps1`  

4. **Apply Git config**  
   Copy or symlink files from `git-config/` to the appropriate locations and merge with your existing Git config (e.g. `includeIf` in `~/.gitconfig` for the custom files).

5. **Restore tool settings**  
   Use each file in `tool-settings/` according to the target app’s import/backup restore flow (e.g. VS Code: import `visual-studio-code.json`; JetBrains: restore from `jetbrains-settings.zip`).

## Notes

- **Backups:** The terminal install scripts create timestamped backups of existing `~/.zshrc`, `~/.bashrc`, or PowerShell profile before overwriting.
- **PowerShell:** The `pwshrc` and modules in `ps-modules/` support both macOS (e.g. PowerShell installed via Homebrew) and Windows.
- **Customization:** Use `~/.zshrc-pre-init`, `~/.zshrc-post-init`, and the equivalent PowerShell hooks for machine-specific or private customizations without editing the tracked configs.
