#!/bin/bash

if command -v git; then
    echo Found git, installing...
    git clone https://github.com/Hellx2/nvim-dots --depth=1 ~/.cache/hellx2-nvim-dots 
    cp -R ~/.cache/hellx2-nvim-dots/config ~/.config/nvim
    cp -R ~/.cache/hellx2-nvim-dots/plugins ~/.local/share/nvim
    rm -rf ~/.cache/hellx2-nvim-dots
else
    echo git is not installed and is required for the install process.
fi
