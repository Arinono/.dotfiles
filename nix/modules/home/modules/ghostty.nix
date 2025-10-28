{...}: {
  # This module is only imported on Linux systems
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      title = "Ghostty";
      font-family = "Dank Mono";
      font-thicken = true;
      cursor-color = "ffffff";
      font-size = 14;
      window-decoration = false;
      theme = "TokyoNight Storm";
      auto-update = "download";
      confirm-close-surface = false;
    };
  };
}
