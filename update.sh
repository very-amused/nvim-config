#!/bin/sh

cp ~/.config/nvim/init.vim ./
cp ~/.config/nvim/coc-settings.json ./
cp ~/.editorconfig ./
jq '.dependencies | keys' ~/.config/coc/extensions/package.json > coc-extensions.json





