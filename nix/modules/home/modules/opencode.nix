{params, ...}: let
  inherit (params) home;
in {
  xdg.configFile."opencode/opencode.jsonc".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "permissions": [
        {
          "action": "read",
          "resource": "**/.env",
          "effect": "deny"
        },
        {
          "action": "read",
          "resource": "**/*.env",
          "effect": "deny"
        },
        {
          "action": "read",
          "resource": "${home}/.dotfiles/nix/modules/secrets/**",
          "effect": "deny"
        }
      ]
    }
  '';
}
