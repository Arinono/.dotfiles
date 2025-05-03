# my dotfiles

## Darwin

### Install nix

[link](https://nixos.org/download/)
```bash
sh <(curl -L https://nixos.org/nix/install)
```

### Clone the repo
```bash
git clone https://github.com/arinono/.dotfiles ~/.dotfiles
cd ~/.dotfiles
nix shell nixpkgs#git-crypt
# Copy the key over
git crypt unlock ~/.ssh/git_crypt_dotfiles
# Then finish pulling
```

### Install homebrew
[link](https://brew.sh/)
```bash
# with nix (not tested yet)
nix -L run ./nix#installBrew

# regular
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


### Install the config

For now, change the information here:

https://github.com//arinono/.dotfiles/blob/9f9c060cd20ed8d83c08fbbf9fdbb02d197720f4/nix/flake.nix#L43-L48

```bash
# 1st run
nix --extra-experimental-features nix-command --extra-experimental flakes \
    run nix-darwin/master#darwin-rebuild -- switch --flake ./nix#<your-hostname>

# later run
darwin-rebuild switch --flake ./nix#<your-hostname>
```
