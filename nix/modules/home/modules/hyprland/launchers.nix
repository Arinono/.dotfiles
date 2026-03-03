{pkgs, ...}: {
  programs.fuzzel = with pkgs; {
    enable = false;
    settings = {
      main = {
        terminal = "${ghostty}/bin/ghostty";
        layer = "overlay";
        width = "80";
        lines = "25";
        horizontal-pad = "8";
      };
      colors = {
        background = "1f2335ff";
        text = "c0caf5ff";
        match = "2ac3deff";
        selection = "363d59ff";
        selection-match = "2ac3deff";
        selection-text = "c0caf5ff";
        border = "7aa2f7ff";
      };
    };
  };

  programs.rofi = with pkgs; {
    enable = true;
    modes = [
      "drun"
      "calc"
    ];
    terminal = "${ghostty}/bin/ghostty";
    theme = ../../rofi/tokyonight_big1.rasi;
    plugins = [
      rofi-calc
    ];
    extraConfig = {
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      display-drun = "";
      display-run = "";
      display-window = "";
      display-calc = "";
    };
  };
}
