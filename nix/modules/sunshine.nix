{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.moonlight-host;
in {
  options.services.moonlight-host = {
    enable = mkEnableOption "Sunshine game streaming host";

    user = mkOption {
      type = types.str;
      description = "User account that will run Sunshine and own game sessions.";
    };
  };

  config = mkIf cfg.enable {
    # AMD GPU driver + VAAPI hardware encoding
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libva-utils # vainfo for debugging
      ];
    };

    # Sunshine expects cap_sys_admin to use KMS capture
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            prep-cmd = [
              {
                do = ''hyprctl keyword monitor "HEADLESS-2, ${"$"}{SUNSHINE_CLIENT_WIDTH}x${"$"}{SUNSHINE_CLIENT_HEIGHT}@${"$"}{SUNSHINE_CLIENT_FPS}, auto, 1"'';
                undo = ''hyprctl keyword monitor "HEADLESS-2, disable"'';
              }
              {
                do = ''hyprctl keyword monitor "desc:ASUSTek COMPUTER INC XG27AQDMG T7LMRS037655, disable"'';
                undo = "";
              }
              {
                do = ''hyprctl keyword monitor "desc:Dell Inc. DELL P2419HC 5784JQ2, disable"'';
                undo = "";
              }
              {
                do = "";
                undo = "hyprctl reload";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
          {
            name = "Steam Big Picture";
            image-path = "steam.png";
            detached = [
              "setsid steam steam://open/bigpicture"
            ];
            prep-cmd = [
              {
                do = "";
                undo = "setsid steam steam://close/bigpicture";
              }
            ];
            exclude-global-prep-cmd = "false";
          }
        ];
      };
    };

    # uinput is required for virtual gamepad/keyboard/mouse input
    boot.kernelModules = ["uinput"];

    hardware.uinput.enable = true;

    users.users.${cfg.user}.extraGroups = [
      "video"
      "render"
      "input"
    ];
  };
}
