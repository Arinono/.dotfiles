{
  pkgs,
  inputs,
  params,
  ...
}: let
  herdrPkg = inputs.herdr.packages.${params.system}.default;
in {
  home.packages = [ herdrPkg ];

  xdg.configFile."herdr/config.toml".text = ''
    # Mimics the tmux configuration in modules/home/modules/tmux.nix.
    # Plain TOML: copy this file to ~/.config/herdr/config.toml on any system
    # that has herdr installed to get the same keybindings/settings.

    onboarding = false

    [terminal]
    default_shell = "zsh"
    shell_mode = "auto"
    new_cwd = "follow"

    [theme]
    name = "tokyo-night"
    auto_switch = true

    [ui]
    mouse_capture = true
    copy_on_select = true
    pane_borders = true
    pane_gaps = true
    confirm_close = false
    prompt_new_tab_name = false
    prompt_new_workspace_name = false
    hide_tab_bar_when_single_tab = false

    [ui.sidebar.agents]
    row_gap = 0
    rows = [
      ["state_icon", "workspace", "tab"],
      ["agent"],
    ]

    [ui.sidebar.spaces]
    row_gap = 0
    rows = [
      ["state_icon", "workspace"],
      ["branch", "git_status"],
    ]

    [session]
    resume_agents_on_restore = true

    [advanced]
    scrollback_limit_bytes = 10000000

    [keys]
    prefix = "ctrl+a"

    # tmux prefix + ?
    help = "prefix+?"
    # moved from prefix+s to avoid shadowing workspace picker
    settings = "prefix+shift+s"
    # tmux prefix + s (choose-tree)
    workspace_picker = "prefix+s"

    new_workspace = "prefix+shift+n"
    rename_workspace = "prefix+shift+w"
    close_workspace = "prefix+shift+k"

    new_tab = "prefix+c"
    rename_tab = "prefix+shift+t"
    previous_tab = "prefix+p"
    next_tab = "prefix+n"
    switch_tab = "prefix+1..9"
    close_tab = "prefix+shift+x"

    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"

    # navigate-mode hjkl instead of arrows.
    # workspace nav uses shifted J/K so it does not clash with pane h/j/k/l.
    navigate_workspace_up = "k"
    navigate_workspace_down = "j"

    swap_pane_left = "prefix+shift+h"
    swap_pane_down = "prefix+shift+j"
    swap_pane_up = "prefix+shift+k"
    swap_pane_right = "prefix+shift+l"

    # semicolon matches tmux's default last-pane binding
    last_pane = "prefix+semicolon"

    split_vertical = "prefix+%"
    split_horizontal = "prefix+\""
    close_pane = "prefix+x"
    zoom = "prefix+z"
    # moved from prefix+r because that is tmux reload
    resize_mode = "prefix+ctrl+r"

    edit_scrollback = "prefix+e"
    copy_mode = "prefix+["
    toggle_sidebar = "prefix+b"

    # tmux prefix + d
    detach = "prefix+d"
    reload_config = "prefix+r"

    # custom commands matching the tmux extras
    [[keys.command]]
    key = "prefix+shift+r"
    type = "popup"
    command = "$EDITOR ~/.config/herdr/config.toml"
    description = "edit herdr config"
    width = "80%"
    height = "80%"

    [[keys.command]]
    key = "prefix+f"
    type = "popup"
    command = "herdr_sessionizer"
    description = "find or create workspace"
    width = "80%"
    height = "80%"

    [[keys.command]]
    key = "prefix+shift+f"
    type = "popup"
    command = "convert"
    description = "convert video"
    width = "80%"
    height = "80%"
  '';
}
