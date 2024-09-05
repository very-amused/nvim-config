#!/bin/bash

cnf_d="$HOME/.config/nvim"
install -d $cnf_d
install -m644 init.lua $cnf_d/init.lua

install -d $cnf_d/snippets
install -m644 snippets/*.snippets $cnf_d/snippets

install -d $cnf_d/spell
install -m644 spell/* $cnf_d/spell
