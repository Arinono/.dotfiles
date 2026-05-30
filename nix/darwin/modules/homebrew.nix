{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [];

    casks = [
      "balenaetcher"
      "cameracontroller"
      "discord"
      "font-meslo-lg-nerd-font"
      "ghostty"
      "istat-menus"
      "vlc"
    ];

    brews = [];

    masApps = {
      Tailscale = 1475387142;
      Wireguard = 1451685025;
    };
  };
}
