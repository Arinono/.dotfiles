{
  config,
  pkgs,
  lib,
  secrets,
  ...
}: {
  services.ssh-agent.enable = true;
  # Import SSH key on setup
  home.activation.importSSHKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set +o nounset

    if [ -n "$VERBOSE" ]; then
      echo "Setting up SSH key..."
    fi

    # Ensure SSH directory exists with correct permissions
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh

    # Create the ed25519 keys
    echo "${secrets.ssh.ed25519.privateKey}" > $HOME/.ssh/id_ed25519
    echo "${secrets.ssh.ed25519.publicKey}" > $HOME/.ssh/id_ed25519.pub

    # Set correct permissions
    chmod 600 $HOME/.ssh/id_ed25519
    chmod 644 $HOME/.ssh/id_ed25519.pub

    if [ -n "$VERBOSE" ]; then
      echo "SSH key setup completed."
    fi
  '';

  # Create ssh config file
  home.file.".ssh/config".text = secrets.ssh.config;

  # Add SSH key to agent on shell startup (only if not already added)
  programs.zsh.initContent = ''
    # Add SSH key to agent if not already added
    if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"; then
      ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    fi
  '';
}
