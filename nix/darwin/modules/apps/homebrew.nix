{
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [];

    casks = [
      "alfred"
      "balenaetcher"
      "calibre"
      "cameracontroller"
      "crystalfetch"
      "discord"
      "docker"
      "font-meslo-lg-nerd-font"
      "flycut"
      "ghostty"
      "istat-menus"
      "scroll-reverser"
      "shottr"
      "signal"
      "soundsource"
      "vlc"
    ];

    brews = [];

    masApps = {
      Tailscale = 1475387142;
      Wireguard = 1451685025;
    };
  };
  
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "install-homebrew";
      runtimeInputs = [bash curl];

      text = ''
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      '';
    })
  ];
}