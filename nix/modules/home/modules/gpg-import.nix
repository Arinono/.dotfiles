{
  pkgs,
  lib,
  secrets,
  ...
}: {
  # Make sure gnupg is installed
  home.packages = with pkgs; [
    gnupg
    pinentry-tty
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    enableSshSupport = true;
  };

  # Import GPG key on setup
  home.activation.importGPGKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set +o nounset

    if [ -n "$VERBOSE" ]; then
      echo "Importing GPG key..."
    fi

    # Create a temporary file for the GPG key
    GPG_KEY_FILE=$(mktemp)
    echo "${secrets.gpg.key.public}" > $GPG_KEY_FILE

    # Import the public key
    ${pkgs.gnupg}/bin/gpg --import $GPG_KEY_FILE

    # Create a temporary file for the private key
    GPG_PRIVATE_KEY_FILE=$(mktemp)
    echo "${secrets.gpg.key.private}" > $GPG_PRIVATE_KEY_FILE

    # Import the private key
    export GPG_TTY=$(tty) || export GPG_TTY=/dev/null
    ${pkgs.gnupg}/bin/gpg --batch --yes --pinentry-mode loopback --allow-secret-key-import --import $GPG_PRIVATE_KEY_FILE

    # Clean up temporary files
    rm -f $GPG_KEY_FILE $GPG_PRIVATE_KEY_FILE

    if [ -n "$VERBOSE" ]; then
      echo "GPG key import completed."
    fi
  '';
}
