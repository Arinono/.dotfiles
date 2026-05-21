{pkgs, ...}: {
  programs.bat = {
    enable = true;

    config = {
      paging = "never";
      theme = "tokyonight_storm";
    };

    themes = {
      tokyonight_storm = {
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "main"; # or pin to a specific commit/tag
          hash = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
        };
        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };
  };
}
