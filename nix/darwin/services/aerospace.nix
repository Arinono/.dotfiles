{pkgs, ...}: {
  services.aerospace = with pkgs; {
    enable = true;

    settings = {
      # Used as a service, so no need for this home manager option
      # start-at-login = true;

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 100;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "horizontal";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      automatically-unhide-macos-hidden-apps = false;

      on-window-detected = [
        {
          "if" = {
            app-name-regex-substring = "signal";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = "messages";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = "finder";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = "notes";
          };
          run = "layout floating";
        }
      ];

      key-mapping.preset = "qwerty";

      gaps = {
        inner = {
          horizontal = 8;
          vertical = 8;
        };
        outer = {
          left = 4;
          bottom = 4;
          top = 4;
          right = 4;
        };
      };

      mode.main.binding = {
        alt-ctrl-shift-f = "fullscreen";
        alt-ctrl-f = "layout floating";

        alt-shift-left = "join-with left";
        alt-shift-down = "join-with down";
        alt-shift-up = "join-with up";
        alt-shift-right = "join-with right";

        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";

        alt-shift-1 = "move-node-to-workspace 1 --focus-follows-window";
        alt-shift-2 = "move-node-to-workspace 2 --focus-follows-window";
        alt-shift-3 = "move-node-to-workspace 3 --focus-follows-window";
        alt-shift-4 = "move-node-to-workspace 4 --focus-follows-window";
        alt-shift-5 = "move-node-to-workspace 5 --focus-follows-window";
        alt-shift-6 = "move-node-to-workspace 6 --focus-follows-window";
        alt-shift-7 = "move-node-to-workspace 7 --focus-follows-window";

        alt-shift-semicolon = "mode service";
        alt-shift-enter = "mode apps";
      };

      workspace-to-monitor-force-assignment = {
        "1" = ["main"]; # terminal
        "2" = ["LG Ultra HD" "main"]; # browser
        "3" = ["DELL" "built-in"]; # browser 2/msg
        "4" = ["LG Ultra HD" "built-in"]; # spotify
        "5" = ["DELL" "main"]; # notes
        "6" = ["main"]; # extra main
        "7" = ["LG Ultra HD" "main"]; # extra 2nd
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];
      };

      mode.apps.binding = {
        alt-b = "exec-and-forget open -a /Applications/Nix\ Apps/Arc.app";
        alt-enter = "exec-and-forget open -a /Applications/Ghostty.app";
        esc = "mode main";
      };
    };
  };
}
