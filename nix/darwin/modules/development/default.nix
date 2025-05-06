{
  pkgs,
  params,
  ...
}: {
  imports = [
    ./tools.nix
    ./services.nix
  ];
  
  # Base system packages for development that should be available to all dev machines
  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
    ripgrep
    fd
    fzf
    jq
    nodejs
  ];
}