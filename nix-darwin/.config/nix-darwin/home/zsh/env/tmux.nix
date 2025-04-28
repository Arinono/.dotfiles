{
  pkgs,
  home,
  ...
}: {
  kill_session = pkgs.writeShellApplication {
    name = "kill_session";
    runtimeInputs = [pkgs.tmux pkgs.toybox];

    text = ''
      current=$(tmux display-message -p '#S')
      nbSession=$(tmux list-session | wc -l)

      if [[ "$nbSession" -gt 1 ]]; then
        tmux switch-client -l
      fi

      tmux kill-session -t "$current"
    '';
  };

  tmux_sessionizer = pkgs.writeShellApplication {
    name = "tmux_sessionizer";
    runtimeInputs = [pkgs.tmux pkgs.toybox pkgs.fzf];

    text = ''
      set +o nounset

      selected=$1

      if [[ -z "$selected" ]]; then
        directories=$(find \
          ~/workspace/wtg \
          ~/workspace/wtg/platform.git \
          ~/workspace/wtg/teleport.git \
          ~/workspace/private \
          ~/workspace \
          -mindepth 1 -maxdepth 1 -type d
        )
        manual_directories=$(echo "$HOME/.dotfiles" | tr ' ' '\n')
        selected=$(printf "%s\n%s" "$manual_directories" "$directories" | fzf)
      fi

      if [[ -z "$selected" ]]; then
        exit 1
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]]  && [[ -z $tmux_running ]]; then
        tmux new-session -ds "$selected_name" -c "$selected"
        exit 0
      fi

      if ! tmux has-session -t="$selected_name" 2> /dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
      fi

      tmux switch-client -t "$selected_name"
    '';
  };

  tmux_worktree_panizer = pkgs.writeShellApplication {
    name = "tmux_worktree_panizer";
    runtimeInputs = [pkgs.tmux pkgs.toybox pkgs.fzf pkgs.git];

    text = ''
      set +o nounset

      if [[ -d ".git" ]]; then
        exit 0
      fi

      selected="$1"
      if [[ -z "$selected" ]]; then
        worktrees=$(git worktree list)
        selected=$(printf "%s" "$worktrees" | fzf | awk '{print $1}')
      fi

      if [[ -z "$selected" ]]; then
        exit 1
      fi

      selected_name=$(basename "$selected" | tr . _)

      tmux neww -n "$selected_name" -c "$selected"
    '';
  };

  variables = {
    TMUX_CONFIG = "${home}/.tmux.conf";
  };

  aliases = with pkgs; {
    tn = "${tmux}/bin/tmux new -s main";
    ta = "${tmux}/bin/tmux attach";
    td = "${tmux}/bin/tmux detach";
    ts = "${tmux}/bin/tmux new-session -s";
    tl = "${tmux}/bin/tmux list-sessions";
    tksv = "${tmux}/bin/tmux kill-server";
    tkss = "${tmux}/bin/tmux kill-session -t";
    tmuxconf = "$EDITOR $TMUX_CONFIG";
  };
}
