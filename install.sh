#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
CONFIG=$HOME/.config

[[ -d ~/.personal ]] || mkdir ~/.personal
[[ -d ~/.ssh ]] || mkdir ~/.ssh
[[ -d $CONFIG ]] || mkdir $CONFIG
[[ -d $CONFIG/alacritty ]] || mkdir $CONFIG/alacritty
[[ -d $CONFIG/htop ]] || mkdir $CONFIG/htop

echo "Linking zsh"
[[ -a ~/.zshrc ]] || ln -s $DOTFILES/zsh/.zshrc ~/.zshrc
[[ -a ~/.zsh_profile ]] || ln -s $DOTFILES/zsh/.zsh_profile ~/.zsh_profile
[[ -a ~/.zlogin ]] || ln -s $DOTFILES/zsh/.zlogin ~/.zlogin
[[ -a ~/.p10k.zsh ]] || ln -s $DOTFILES/zsh/.p10k.zsh ~/.p10k.zsh
touch ~/.hushlogin

echo "Linking nvim"
[[ -d $CONFIG/nvim ]] || ln -s $DOTFILES/nvim $CONFIG/nvim

echo "Linking tmux"
[[ -a ~/.tmux.conf ]] || ln -s $DOTFILES/tmux/.tmux.conf ~/.tmux.conf

echo "Linking personal todo"
[[ -a ~/.personal/todo.md ]] || ln -s $DOTFILES/personal/todo.md ~/.personal/todo.md

echo "Linking git config"
[[ -a ~/.gitconfig ]] || ln -s $DOTFILES/git/.gitconfig ~/.gitconfig
[[ -a ~/.gitignore ]] || ln -s $DOTFILES/git/.gitignore ~/.gitignore

echo "Linking alacritty"
[[ -a $CONFIG/alacritty/alacritty.yml ]] || ln -s $DOTFILES/term/alacritty/alacritty.yml $CONFIG/alacritty/alacritty.yml

echo "Linking htop"
ln -s $DOTFILES/htop/htoprc $CONFIG/htop/htoprc
