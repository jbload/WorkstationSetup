# WorkstationSetup

A repository of configuration and tooling used to set up and standardize a development workstation. Clone this repo and run the included scripts to install tools and apply settings so new machines (or fresh installs) match a consistent environment.

## What's in this repo

| Directory / file | Purpose |
|------------------|--------|
| **tools.sh** | Homebrew-based install script for core CLI tools, languages (Java, Node, Python, .NET), Kubernetes tooling, browsers, media apps, AI tools, and optional extras. Run on macOS after installing [Homebrew](https://brew.sh). While it can be run in its entirety, most likely you'll want to pick and choose the specific tools you need for a particular machine.|
| **git-config/** | Global Git config layers: shared defaults (`gitconfig.shared`), platform overlays (`gitconfig.macos`, `gitconfig.linux`, `gitconfig.windows`), and shared ignore patterns (`gitignore`). Include these from the machine-owned `~/.gitconfig`. |
| **terminal-settings/** | Shell configs and terminal profiles: shared zsh, bash, and PowerShell profiles (`*.shared.sh`, `*.shared.ps1`), Oh My Posh theme (`.oh-my-posh.justin.json`), and profiles for iTerm2 and Windows Terminal. |
| **verify-config.sh** | Checks whether machine-owned entrypoints like `~/.gitconfig`, `~/.zshrc`, `~/.bashrc`, and the PowerShell profile include/source the expected repo-managed files. |
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

3. **Wire entrypoint config files**  
   Keep the real home files machine-owned and source/include the repo-managed files from them.

   Example `~/.gitconfig` on macOS:
   ```ini
   [include]
       path = ~/src/Three21/WorkstationSetup/git-config/gitconfig.shared

   [include]
       path = ~/src/Three21/WorkstationSetup/git-config/gitconfig.macos

   [include]
       path = ~/.gitconfig.local-machine
   ```

   Example `~/.zshrc`:
   ```bash
   source ~/src/Three21/WorkstationSetup/terminal-settings/zshrc.shared.sh
   ```

   Check the current machine:
   ```bash
   ./verify-config.sh
   ```

4. **Restore tool settings**  
   Use each file in `tool-settings/` according to the target app’s import/backup restore flow (e.g. VS Code: import `visual-studio-code.json`; JetBrains: restore from `jetbrains-settings.zip`).

## Notes

- **Entrypoints:** Files like `~/.gitconfig`, `~/.zshrc`, `~/.bashrc`, and PowerShell's profile should stay machine-owned so work tools can safely add managed settings.
- **Shared defaults:** Repo-managed files ending in `.shared` are intended to behave the same across machines.
- **Platform overlays:** Include exactly one Git platform overlay from `gitconfig.macos`, `gitconfig.linux`, or `gitconfig.windows`.
- **Local-machine settings:** Use `~/.gitconfig.local-machine` for Git settings that differ on this machine, such as `maintenance.repo` entries or work-only overrides.
- **Shell local-machine config:** Use `~/.zshrc.local-machine-config` / `~/.bashrc.local-machine-config` for values consumed by the shared config, such as `WORKSPACE` or `GIT_REPOS`.
- **Shell local-machine overrides:** Use `~/.zshrc.local-machine-overrides` / `~/.bashrc.local-machine-overrides` for aliases, functions, PATH changes, or environment values that should override shared config.
- **PowerShell:** The `pwshrc.shared.ps1` and modules in `ps-modules/` support both macOS (e.g. PowerShell installed via Homebrew) and Windows. PowerShell local-machine files use `.pwshrc.local-machine-config.ps1` and `.pwshrc.local-machine-overrides.ps1`.
