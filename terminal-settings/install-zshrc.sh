#!/bin/zsh

echo Copying zsh profile to ~/.zshrc...
cp zshrc ~/.zshrc

if [ -f ~/.zshrc-machine-specific ]; then
    echo ~/.zshrc-machine-specific file already exists...
else
    echo Creating blank ~/.zshrc-machine-specific file...
    touch ~/.zshrc-machine-specific
fi

echo Done.