#!/usr/bin/env bash

[[ -d ~/.personal ]] || mkdir ~/.personal
[[ -d ~/.ssh ]] || mkdir ~/.ssh
[[ -d ~/.config ]] || mkdir ~/.config

echo "Linking zsh"
ln -s ./zsh/.zshrc ~/.zshrc
ln -s ./zsh/.zsh_profile ~/.zsh_profile
ln -s ./zlogin ~/.zlogin
ln -s ./zsh/.p10k.zsh ~/.p10k.zsh
touch ~/.hushlogin

echo "Linking nvim"
ln -s ./nvim ~/.config/nvim

echo "Linking tmux"
ln -s ./tmux/.tmux.conf ~/.tmux.conf

echo "Linking personal todo"
ln -s ./personal/todo.md ~/.personal/todo.md

echo "Linking git config"
ln -s ./git/.gitconfig ~/.gitconfig
ln -s ./git/.gitignore ~/.gitignore
