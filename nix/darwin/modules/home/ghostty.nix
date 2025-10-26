{...}: {
  xdg.configFile.ghostty = {
    target = "ghostty/config";
    text = ''
      title = Ghostty
      font-family = Dank Mono
      font-thicken = true
      cursor-color = ffffff
      font-size = 14
      window-decoration = false
      theme = Tokyonight Storm
      auto-update = download
      confirm-close-surface = false
    '';
  };
}
