#!/bin/bash

echo Copying bash profile to ~/.bashrc...
cp bashrc ~/.bashrc

if [ -f ~/.bashrc-machine-specific ]; then
    echo ~/.bashrc-machine-specific file already exists...
else
    echo Creating blank ~/.bashrc-machine-specific file...
    touch ~/.bashrc-machine-specific
fi

echo Done.