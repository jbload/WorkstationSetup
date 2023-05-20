#!/bin/bash

echo Backing up ~/bashrc...
cp ~/.bashrc "~/.bashrc-$(date +%F_%R).backup"

echo Copying bash profile to ~/.bashrc...
cp bashrc ~/.bashrc

if [ -f ~/.bashrc-pre-init ]; then
    echo ~/.bashrc-pre-init file already exists...
else
    echo Creating blank ~/.bashrc-pre-init file...
    touch ~/.bashrc-pre-init
fi

if [ -f ~/.bashrc-post-init ]; then
    echo ~/.bashrc-post-init file already exists...
else
    echo Creating blank ~/.bashrc-post-init file...
    touch ~/.bashrc-post-init
fi

echo Done.