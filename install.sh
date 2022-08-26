#!/usr/bin/env bash

[[ -d ~/.personal ]] || mkdir ~/.personal
[[ -d ~/.ssh ]] || mkdir ~/.ssh
[[ -d ~/.config ]] || mkdir ~/.config

DOTFILES=$HOME/.dotfiles

echo "Linking zsh"
ln -s $DOTFILES/zsh/.zshrc ~/.zshrc
ln -s $DOTFILES/zsh/.zsh_profile ~/.zsh_profile
ln -s $DOTFILES/zsh/.zlogin ~/.zlogin
ln -s $DOTFILES/zsh/.p10k.zsh ~/.p10k.zsh
touch ~/.hushlogin

echo "Linking nvim"
ln -s $DOTFILES/nvim ~/.config/nvim

echo "Linking tmux"
ln -s $DOTFILES/tmux/.tmux.conf ~/.tmux.conf

echo "Linking personal todo"
ln -s $DOTFILES/personal/todo.md ~/.personal/todo.md

echo "Linking git config"
ln -s $DOTFILES/git/.gitconfig ~/.gitconfig
ln -s $DOTFILES/git/.gitignore ~/.gitignore
