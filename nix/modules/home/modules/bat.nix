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
          hash = "sha256-4zfkv3egdWJ/GCWUehV0MAIXxsrGT82Wd1Qqj1SCGOk=";
        };
        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };
  };
}
