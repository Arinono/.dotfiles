{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 0;
    baseIndex = 1;
    historyLimit = 100000;
    mouse = true;
    focusEvents = true;
    plugins = with pkgs; [
      tmuxPlugins.dracula
      tmuxPlugins.resurrect
    ];
    extraConfig = ''
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g status-left-length 50

      set -gq mouse-select-pane on
      set -gq mouse-resize-pane on
      set -gq mouse-select-window on

      bind R neww -n "tmux-conf" "$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"
      bind r source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display-message "tmux reloaded"
      bind s choose-tree -sZ -O name
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      bind -r C-h resizep -L
      bind -r C-j resizep -D
      bind -r C-k resizep -U
      bind -r C-l resizep -R
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind C new-session -ds caffeinate "caffeinate -d"
      bind f run-shell "tmux neww ~/.local/bin/tmux-sessionizer"
      bind g run-shell "tmux neww ~/.local/bin/tmux-worktree-panizer"
      bind K run-shell "~/.local/bin/kill-session"
      bind F run-shell "tmux neww ~/.local/bin/convert"

      set -g @plugin 'dracula/tmux'

      set -g @dracula-plugins "time"
      set -g @dracula-show-powerline true
      set -g @dracula-show-flags true
      set -g @dracula-show-left-icon session
      set -g @dracula-day-month true
      set -g @dracula-show-timezone false
      set -g @dracula-military-time true
    '';
  };
}
