{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };

    taps = [];

    casks = [
      "balenaetcher"
      "cameracontroller"
      "font-meslo-lg-nerd-font"
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
