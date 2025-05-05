{
  config,
  pkgs,
  lib,
  secrets,
  ...
}: {
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
}

