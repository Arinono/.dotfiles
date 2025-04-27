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
