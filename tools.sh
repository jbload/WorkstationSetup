#!/bin/zsh

typeset -A INSTALLERS
INSTALLERS=(
  # Core installations
  essentials                  install_essentials
  
  # Editors
  editors_sublime             install_editors_sublime
  editors_vscode              install_editors_vscode
  editors_zed                 install_editors_zed
  editors_all                 install_editors_all
  
  # Terminals
  terminals_ghostty           install_terminals_ghostty
  terminals_iterm2            install_terminals_iterm2
  terminals_warp              install_terminals_warp
  terminals_all               install_terminals_all
  
  # JetBrains
  jetbrains                   install_jetbrains
  
  # Git tools
  git_gui_apps                install_git_gui_apps
  pair_programming            install_pair_programming_tools
  
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
  cloud_aws_cli               install_cloud_aws_cli
  
  # Databases & messaging
  kafka                       install_kafka
  mysql                       install_mysql
  mysql_client                install_mysql_client
  rabbitmq                    install_rabbitmq
  redis                       install_redis
  
  # AI Development tools
  ai_dev_github_copilot       install_ai_dev_github_copilot
  ai_dev_claude_code          install_ai_dev_claude_code
  ai_dev_opencode             install_ai_dev_opencode
  ai_dev_cursor               install_ai_dev_cursor
  ai_dev_all                  install_ai_dev_all
  
  # AI tools
  ai_ollama                   install_ai_ollama
  ai_lmstudio                 install_ai_lmstudio
  ai_chatbots                 install_ai_chatbots
  
  # Browsers
  browsers_firefox            install_browsers_firefox
  browsers_chrome             install_browsers_chrome
  browsers_edge               install_browsers_edge
  browsers_all                install_browsers_all
  
  # Machine presets
  @home_setup                 install_home_machine
  @home_setup_optionals       install_home_machine_optionals
  @work_setup                 install_work_machine
)

install_essentials() {
  brew install --cask appcleaner
  brew install --cask beyond-compare
  brew install --cask font-cascadia-code
  brew install --cask font-cascadia-code-pl
  brew install --cask font-cascadia-mono
  brew install --cask font-cascadia-mono-pl
  brew install --cask postman
  brew install --cask powershell
  brew install --cask rectangle
  brew install ack
  brew install coreutils
  brew install direnv
  brew install fig
  brew install git
  brew install git-lfs  
  brew install httpie
  brew install jq
  brew install ripgrep
  brew install swagger-codegen
  brew install vim
  brew install yq  
}

install_editors_sublime() {
  brew install --cask sublime-text
}

install_editors_vscode() {
  brew install --cask visual-studio-code
}

install_editors_zed() {
  brew install --cask zed
}

install_editors_all() {
  install_editors_sublime
  install_editors_vscode
  install_editors_zed
}

install_terminals_ghostty() {
  brew install --cask ghostty
}

install_terminals_iterm2() {
  brew install --cask iterm2
}

install_terminals_warp() {
  brew install --cask warp
}

install_terminals_all() {
  install_terminals_ghostty
  install_terminals_iterm2
  install_terminals_warp
}

install_jetbrains() {  
  brew install --cask jetbrains-toolbox
}

install_git_gui_apps() {
  brew install --cask sourcetree
}

install_pair_programming_tools() {
  brew tap git-duet/tap
  brew install git-duet
}

install_dev_stack_python() {
  brew install pyenv
  brew install pyenv-virtualenv
  pyenv install 3.12 && pyenv global 3.12
  brew install jupyterlab
  brew install uv
}

install_dev_stack_node() {
  brew install node@22 && brew link --overwrite node@22
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
  brew install --cask temurin
  brew install gradle
  brew install liquibase
  brew install maven
  brew install prettier  
  npm install gradle-upgrade-interactive -g
}

install_dev_stack_spring_boot() {
  install_dev_stack_java
  brew tap spring-io/tap
  brew install spring-boot
}

install_dev_stack_dotnet() {
  brew install --cask dotnet-sdk
}

install_dev_stack_ios() {
  brew install carthage
  brew install fastlane  
  brew install --cask sf-symbols
}

install_docker() {
  brew install --cask docker
}

install_kubernetes_cli() {
  brew install helm
  brew install kubectx
  brew install kubernetes-cli
}

install_microk8s() {
  brew tap ubuntu/microk8s
  brew install microk8s
}

install_cloud_aws_cli() {
  brew install awscli
}

install_kafka() {
  brew install kafka
}

install_mysql_client() {
  brew install mysql-client
}

install_mysql() {
  brew install mysql
  install_mysql_client
}

install_rabbitmq() {
  brew install rabbitmq
}

install_redis() {
  brew install redis
}

install_ai_dev_github_copilot() {
  brew install gh
  gh auth login
  gh extension install github/gh-copilot
  brew install --cask github-copilot-for-xcode
}

install_ai_dev_claude_code() {
  brew install --cask claude-code
  brew install tmux
  brew install claude-squad
  ln -s "$(brew --prefix)/bin/claude-squad" "$(brew --prefix)/bin/cs"
  mkdir $WORKSPACE/.claude-squad
  ln -s $WORKSPACE/.claude-squad ~/.claude-squad
}

install_ai_dev_opencode() {
  brew install opencode
}

install_ai_dev_cursor() {
  brew install --cask cursor
}

install_ai_dev_all() {
  install_ai_dev_claude_code
  install_ai_dev_cursor
  install_ai_dev_github_copilot
  install_ai_dev_opencode
}

install_ai_ollama() {
  brew install ollama
}

install_ai_lmstudio() {  
  brew install --cask lm-studio
}

install_ai_chatbots() {
  brew install --cask chatgpt
  brew install --cask claude
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

install_browsers_all() {
  install_browsers_chrome
  install_browsers_edge
  install_browsers_firefox
}

install_home_machine() {
  install_ai_chatbots
  install_ai_dev_all
  install_browsers_edge
  install_dev_stack_angular
  install_dev_stack_dotnet
  install_dev_stack_ios
  install_dev_stack_java
  install_dev_stack_python
  install_dev_stack_react
  install_docker
  install_editors_all
  install_essentials
  install_jetbrains
  install_kubernetes_cli
  install_mysql_client
  install_terminals_all

  brew install --cask downie
  brew install --cask guitar-pro
  brew install --cask iina
  brew install --cask imazing
  brew install --cask microsoft-remote-desktop
  brew install --cask musescore
  brew install --cask permute
  brew install sentry-cli  
}

install_home_machine_optionals() {
  brew install --cask calibre  
  brew install --cask discord
  brew install --cask drawio
  brew install --cask google-earth-pro
  brew install --cask miro
  brew install --cask orbstack
  brew install --cask slack
  brew install --cask zoom
  brew install ffmpeg  
  brew install terraform
}

install_work_machine() {
  install_ai_dev_claude_code
  install_ai_dev_github_copilot
  install_browsers_chrome
  install_editors_sublime
  install_editors_vscode
  install_essentials
  install_jetbrains
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