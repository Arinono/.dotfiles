#!/usr/bin/env bash

set -e

DOTFILES=$HOME/.dotfiles
CONFIG=$HOME/.config
BINS=$HOME/.local/bin


echo "Cleaning"

for i in $(find "$HOME" -maxdepth 1 -type l);
do
    found=$(readlink "$i")
    if [ -z "$found" ]
    then
        echo "Unable to find $i"
        rm "$i"
    fi
done

for i in .profile .bashrc .zshrc
do
    [ -f "$HOME/$i" ] && rm "$HOME/$i"
done

echo "Stowing dotfiles"
stow -v stow \
  zsh \
  tmux \
  nvim \
  git \
  htop \
  nix \
  yabai \
  skhd \
  gh-dash \
  wezterm \
  ghostty

echo "Linking personal todo"
[[ -d ~/.personal ]] || mkdir ~/.personal
[[ -f ~/.personal/todo.md ]] || ln -s "$DOTFILES"/personal/todo.md ~/.personal/todo.md

echo "Linking bins"
[[ -d $BINS ]] || mkdir "$BINS"
[[ -d $BINS/wtg ]] || ln -s "$DOTFILES"/wtg/bin "$BINS"/wtg
[[ -d $BINS/personal ]] || ln -s "$DOTFILES"/personal/bin "$BINS"/personal
ln -s "$DOTFILES"/bin/* "$BINS"
