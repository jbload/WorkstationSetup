#!/bin/zsh

echo Backing up ~/.zshrc...
cp ~/.zshrc ~/.zshrc-$(date +%F_%R).backup

echo Copying zsh profile to ~/.zshrc...
cp zshrc ~/.zshrc

if [ -f ~/.zshrc-pre-init ]; then
    echo ~/.zshrc-pre-init file already exists...
else
    echo Creating blank ~/.zshrc-pre-init file...
    touch ~/.zshrc-pre-init
fi

if [ -f ~/.zshrc-post-init ]; then
    echo ~/.zshrc-post-init file already exists...
else
    echo Creating blank ~/.zshrc-post-init file...
    touch ~/.zshrc-post-init
fi

echo Done.