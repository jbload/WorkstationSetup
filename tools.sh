#!/bin/zsh

SCRIPT_DIR="${0:A:h}"
PYTHON_VERSION=3.14
NODE_VERSION=26
JAVA_VERSION=25

typeset -A INSTALLERS
INSTALLERS=(
  # Core installations
  essentials                  install_essentials

  # Editors
  editors_sublime             install_editors_sublime
  editors_vscode              install_editors_vscode
  editors_zed                 install_editors_zed

  # Terminals
  terminals_cmux              install_terminals_cmux
  terminals_ghostty           install_terminals_ghostty
  terminals_iterm2            install_terminals_iterm2
  terminals_warp              install_terminals_warp

  # Development tools
  dev_tools_jetbrains         install_dev_tools_jetbrains
  dev_tools_git_gui           install_dev_tools_git_gui
  dev_tools_git_duet          install_dev_tools_git_duet

  # File transfer
  file_transfer_cyberduck     install_file_transfer_cyberduck

  # Development stacks
  python_stack                install_dev_stack_python
  node_stack                  install_dev_stack_node
  angular_stack               install_dev_stack_angular
  react_stack                 install_dev_stack_react
  java_stack                  install_dev_stack_java
  spring_boot_stack           install_dev_stack_spring_boot
  dotnet_stack                install_dev_stack_dotnet
  ios_stack                   install_dev_stack_ios

  # Containers & Kubernetes
  docker                      install_docker
  kubernetes_cli              install_kubernetes_cli
  microk8s                    install_microk8s

  # Cloud
  cloud_azure_cli             install_cloud_azure_cli
  cloud_aws_cli               install_cloud_aws_cli

  # Data
  data_kafka                  install_data_kafka
  data_mysql                  install_data_mysql
  data_mysql_client           install_data_mysql_client
  data_rabbitmq               install_data_rabbitmq
  data_redis                  install_data_redis

  # AI Development tools
  ai_dev_github_copilot       install_ai_dev_github_copilot
  ai_dev_claude_code          install_ai_dev_claude_code
  ai_dev_codex                install_ai_dev_codex
  ai_dev_xcode_mcp            install_ai_dev_xcode_mcp
  ai_dev_conductor            install_ai_dev_conductor
  ai_dev_opencode             install_ai_dev_opencode
  ai_dev_cursor               install_ai_dev_cursor

  # AI tools
  ai_ollama                   install_ai_ollama
  ai_lmstudio                 install_ai_lmstudio
  ai_chatbots_chatgpt         install_ai_chatbots_chatgpt
  ai_chatbots_claude          install_ai_chatbots_claude
  ai_chatbots_gemini          install_ai_chatbots_gemini

  # Browsers
  browsers_firefox            install_browsers_firefox
  browsers_chrome             install_browsers_chrome
  browsers_edge               install_browsers_edge

  # Machine presets
  @home_setup                 install_home_machine
  @home_setup_optionals       install_home_machine_optionals
  @work_setup                 install_work_machine
)

install_essentials() {
  brew install --cask \
    appcleaner \
    beyond-compare \
    font-cascadia-code \
    font-cascadia-code-pl \
    font-cascadia-mono \
    font-cascadia-mono-pl \
    postman \
    powershell \
    rectangle

  brew install \
    bat \
    coreutils \
    direnv \
    fd \
    git \
    git-lfs \
    gh \
    httpie \
    jq \
    ripgrep \
    shellcheck \
    shfmt \
    swagger-codegen \
    tmux \
    vim \
    yq
}

install_editors_sublime() {
  brew install --cask sublime-text
}

install_editors_vscode() {
  brew install --cask visual-studio-code
}

install_editors_zed() {
  brew install --cask zed
  mkdir -p "$HOME/.config/zed"
  ln -sf "$SCRIPT_DIR/tool-settings/zed/settings.json" "$HOME/.config/zed/settings.json"
}

install_terminals_cmux() {
  brew install --cask cmux
  sudo ln -sf "/Applications/cmux.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux
  mkdir -p "$HOME/.config/cmux"
  ln -sf "$SCRIPT_DIR/terminal-settings/cmux.json" "$HOME/.config/cmux/cmux.json"
  mkdir -p "$HOME/Library/Application Support/com.cmuxterm.app"
  ln -sf "$SCRIPT_DIR/terminal-settings/ghostty.conf" "$HOME/Library/Application Support/com.cmuxterm.app/config.ghostty"
}

install_terminals_ghostty() {
  brew install --cask ghostty
  mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
  ln -sf "$SCRIPT_DIR/terminal-settings/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
}

install_terminals_iterm2() {
  brew install --cask iterm2
}

install_terminals_warp() {
  brew install --cask warp
}

install_dev_tools_jetbrains() {
  brew install --cask jetbrains-toolbox
}

install_dev_tools_git_gui() {
  brew install --cask sourcetree
}

install_dev_tools_git_duet() {
  brew install git-duet/tap/git-duet
}

install_file_transfer_cyberduck() {
  brew install --cask cyberduck
}

install_dev_stack_python() {
  brew install \
    pyenv \
    pyenv-virtualenv

  pyenv install "$PYTHON_VERSION" && pyenv global "$PYTHON_VERSION"

  brew install \
    jupyterlab \
    uv
}

install_dev_stack_node() {
  brew install "node@$NODE_VERSION" && brew link --overwrite "node@$NODE_VERSION"
}

install_dev_stack_angular() {
  install_dev_stack_node
  npm install @angular/cli -g
}

install_dev_stack_react() {
  install_dev_stack_node
  corepack enable
}

install_dev_stack_java() {
  brew install --cask "temurin@$JAVA_VERSION"

  brew install \
    gradle \
    liquibase \
    maven \
    prettier

  npm install gradle-upgrade-interactive -g
}

install_dev_stack_spring_boot() {
  install_dev_stack_java
  brew install spring-io/tap/spring-boot
}

install_dev_stack_dotnet() {
  brew install --cask dotnet-sdk
}

install_dev_stack_ios() {
  brew install \
    carthage \
    fastlane

  brew install --cask sf-symbols

  brew install \
    swift-format \
    xcbeautify
}

install_docker() {
  brew install --cask docker
}

install_kubernetes_cli() {
  brew install \
    helm \
    kubectx \
    kubernetes-cli
}

install_microk8s() {
  brew install ubuntu/microk8s/microk8s
}

install_cloud_aws_cli() {
  brew install awscli
}

install_cloud_azure_cli() {
  brew install azure-cli
}

install_data_kafka() {
  brew install kafka
}

install_data_mysql_client() {
  brew install mysql-client
}

install_data_mysql() {
  brew install mysql
  install_data_mysql_client
}

install_data_rabbitmq() {
  brew install rabbitmq
}

install_data_redis() {
  brew install redis
}

install_ai_dev_github_copilot() {
  gh auth login
  gh extension install github/gh-copilot
  brew install --cask github-copilot-for-xcode
}

install_ai_dev_claude_code() {
  brew install --cask claude-code
}

install_ai_dev_codex() {
  brew install codex
}

install_ai_dev_xcode_mcp() {
  brew install getsentry/xcodebuildmcp/xcodebuildmcp

  if command -v claude >/dev/null 2>&1; then
    claude mcp add --transport stdio xcode -- xcrun mcpbridge
    claude mcp add XcodeBuildMCP -- xcodebuildmcp mcp
  else
    echo "Claude Code is not installed; skipping Xcode MCP configuration."
  fi

  if command -v codex >/dev/null 2>&1; then
    codex mcp add xcode -- xcrun mcpbridge
    codex mcp add XcodeBuildMCP -- xcodebuildmcp mcp
  else
    echo "Codex is not installed; skipping Xcode MCP configuration."
  fi
}

install_ai_dev_conductor() {
  brew install --cask conductor
}

install_ai_dev_opencode() {
  brew install opencode
}

install_ai_dev_cursor() {
  brew install --cask cursor
}

install_ai_ollama() {
  brew install ollama
}

install_ai_lmstudio() {
  brew install --cask lm-studio
}

install_ai_chatbots_chatgpt() {
  brew install --cask chatgpt
}

install_ai_chatbots_claude() {
  brew install --cask claude
}

install_ai_chatbots_gemini() {
  brew install --cask google-gemini
}

install_browsers_firefox() {
  brew install --cask firefox
}

install_browsers_chrome() {
  brew install --cask google-chrome
}

install_browsers_edge() {
  brew install --cask microsoft-edge
}

install_home_machine() {
  install_ai_chatbots_chatgpt
  install_ai_chatbots_claude
  install_ai_chatbots_gemini
  install_ai_dev_claude_code
  install_ai_dev_codex
  install_ai_dev_xcode_mcp
  install_ai_dev_conductor
  install_ai_dev_cursor
  install_ai_dev_github_copilot
  install_ai_dev_opencode
  install_browsers_edge
  install_dev_stack_angular
  install_dev_stack_dotnet
  install_dev_stack_ios
  install_dev_stack_java
  install_dev_stack_python
  install_dev_stack_react
  install_docker
  install_editors_sublime
  install_editors_vscode
  install_editors_zed
  install_essentials
  install_dev_tools_jetbrains
  install_kubernetes_cli
  install_data_mysql_client
  install_terminals_cmux
  install_terminals_ghostty
  install_terminals_iterm2
  install_terminals_warp

  brew install --cask \
    downie \
    guitar-pro \
    iina \
    imazing \
    microsoft-remote-desktop \
    musescore \
    permute \
    plex

  brew install getsentry/tools/sentry-cli
}

install_home_machine_optionals() {
  brew install --cask \
    calibre \
    discord \
    drawio \
    google-earth-pro \
    miro \
    orbstack \
    slack \
    zoom

  brew install \
    ffmpeg \
    terraform
}

install_work_machine() {
  install_ai_dev_claude_code
  install_ai_dev_github_copilot
  install_browsers_chrome
  install_editors_sublime
  install_editors_vscode
  install_essentials
  install_dev_tools_jetbrains
  install_terminals_cmux
  install_terminals_ghostty
  install_terminals_iterm2

  brew install meetingbar
}

# fzf setup
if ! command -v fzf >/dev/null 2>&1; then
  echo "🍺 Installing fzf for menu selection support."
  brew install fzf
  if [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
    $(brew --prefix)/opt/fzf/install --no-update-rc
  fi
fi

clear
choices=$(printf "%s\n" "${(@kO)INSTALLERS}" \
  | fzf --multi --prompt="Use ↑ ↓ to move, TAB to toggle selections and ENTER to submit selections. ")

for choice in ${(f)choices}; do
  echo "Installing: $choice"
  ${INSTALLERS[$choice]}
done
