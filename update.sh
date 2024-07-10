#!/bin/sh

cp ~/.config/nvim/init.lua ./
[ -d spell ] || mkdir spell
cp ~/.config/nvim/spell/*.add ./spell/
[ -d snippets ] || mkdir snippets
cp ~/.config/nvim/snippets/*.snippets ./snippets/
cp ~/.editorconfig ./
