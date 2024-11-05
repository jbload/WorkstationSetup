#!/usr/bin/env bash

#Core
brew tap git-duet/tap
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew install ack
brew install coreutils
brew install direnv
brew install fig
brew install git
brew install git-duet
brew install git-lfs
brew install httpie
brew install jq
brew install prettier
brew install vim
brew install yq
brew install --cask appcleaner
brew install --cask beyond-compare
brew install --cask font-cascadia-code
brew install --cask font-cascadia-code-pl
brew install --cask font-cascadia-mono
brew install --cask font-cascadia-mono-pl
brew install --cask iterm2
brew install --cask postman
brew install --cask rectangle
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask warp

# Java
brew tap spring-io/tap
brew install gradle
brew install maven
brew install spring-boot
brew install --cask jetbrains-toolbox
brew install --cask temurin
npm install gradle-upgrade-interactive -g

# JavaScript/TypeScript
brew install node@22 && brew link --overwrite node@22
corepack enable
npm install @angular/cli -g

# .NET
brew install --cask dotnet-sdk

# iOS
brew install carthage
brew install fastlane
brew install swiftlint

# Kubernetes
brew install helm
brew install kubectx
brew install kubernetes-cli

# Microk8s
brew tap ubuntu/microk8s
brew install microk8s

# Python
brew install pyenv
brew install pyenv-virtualenv
pyenv install 3.12 && pyenv global 3.12

# Browsers
brew install --cask firefox
brew install --cask google-chrome
brew install --cask microsoft-edge

# Music
brew install --cask guitar-pro
brew install --cask musescore

# Media
brew install --cask downie
brew install --cask iina
brew install --cask permute
brew install --cask vlc

# AI
brew install ollama
brew install --cask chatgpt

# Miscellaneous/Optional
brew install awscli
brew install kafka
brew install liquibase
brew install meetingbar
brew install mysql
brew install mysql-client
brew install rabbitmq
brew install redis
brew install sentry-cli
brew install swagger-codegen
brew install terraform
brew install --cask boop
brew install --cask docker
brew install --cask drawio
brew install --cask microsoft-remote-desktop
brew install --cask miro
brew install --cask orbstack
brew install --cask powershell
brew install --cask sf-symbols
brew install --cask slack
brew install --cask sourcetree
brew install --cask zoom
