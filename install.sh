#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
CONFIG=$HOME/.config
BINS=$HOME/.local/bin

[[ -d ~/.personal ]] || mkdir ~/.personal
[[ -d ~/.ssh ]] || mkdir ~/.ssh
[[ -d $CONFIG ]] || mkdir "$CONFIG"
[[ -d $CONFIG/alacritty ]] || mkdir "$CONFIG"/alacritty
[[ -d $CONFIG/htop ]] || mkdir "$CONFIG"/htop
[[ -d $CONFIG/nix ]] || mkdir "$CONFIG"/nix
[[ -d $CONFIG/spotifyd ]] || mkdir "$CONFIG"/spotifyd
[[ -d $CONFIG/spotify-tui ]] || mkdir "$CONFIG"/spotify-tui
[[ -d $BINS ]] || mkdir "$BINS"

echo "Linking zsh"
[[ -f ~/.zshrc ]] || ln -s "$DOTFILES"/zsh/.zshrc ~/.zshrc
[[ -f ~/.zsh_profile ]] || ln -s "$DOTFILES"/zsh/.zsh_profile ~/.zsh_profile
[[ -f ~/.zlogin ]] || ln -s "$DOTFILES"/zsh/.zlogin ~/.zlogin
[[ -f ~/.p10k.zsh ]] || ln -s "$DOTFILES"/zsh/.p10k.zsh ~/.p10k.zsh
touch ~/.hushlogin

echo "Linking nvim"
[[ -d $CONFIG/nvim ]] || ln -s "$DOTFILES"/nvim "$CONFIG"/nvim

echo "Linking tmux"
[[ -f ~/.tmux.conf ]] || ln -s "$DOTFILES"/tmux/.tmux.conf ~/.tmux.conf

echo "Linking personal todo"
[[ -f ~/.personal/todo.md ]] || ln -s "$DOTFILES"/personal/todo.md ~/.personal/todo.md

echo "Linking git config"
[[ -f ~/.gitconfig ]] || ln -s "$DOTFILES"/git/.gitconfig ~/.gitconfig
[[ -f ~/.gitignore ]] || ln -s "$DOTFILES"/git/.gitignore ~/.gitignore

echo "Linking alacritty"
[[ -f $CONFIG/alacritty/alacritty.yml ]] || ln -s "$DOTFILES"/term/alacritty/alacritty.yml "$CONFIG"/alacritty/alacritty.yml

echo "Linking htop"
[[ -f $CONFIG/htop/htoprc ]] || ln -s "$DOTFILES"/htop/htoprc "$CONFIG"/htop/htoprc

echo "Linking nix"
[[ -f $CONFIG/nix/nix.conf ]] || ln -s "$DOTFILES"/nix/nix.conf "$CONFIG"/nix/nix.conf

echo "Linking bins"
[[ -d $BINS/wtg ]] || ln -s "$DOTFILES"/wtg/bin "$BINS"/wtg
[[ -d $BINS/personal ]] || ln -s "$DOTFILES"/personal/bin "$BINS"/personal
ln -s "$DOTFILES"/bin/* "$BINS"

echo "Linking spotify"
[[ -f $CONFIG/spotifyd/spotifyd.conf ]] || ln -s "$DOTFILES"/personal/spotify/spotifyd/spotifyd.conf "$CONFIG"/spotifyd/spotifyd.conf
[[ -f $CONFIG/spotify-tui/client.yml ]] || ln -s "$DOTFILES"/personal/spotify/spotify-tui/client.yml "$CONFIG"/spotify-tui/client.yml
[[ -f $CONFIG/spotify-tui/config.yml ]] || ln -s "$DOTFILES"/personal/spotify/spotify-tui/config.yml "$CONFIG"/spotify-tui/config.yml

echo "Linking yabai"
[[ -f ~/.yabairc ]] || ln -s "$DOTFILES"/yabai/.yabairc ~/.yabairc
