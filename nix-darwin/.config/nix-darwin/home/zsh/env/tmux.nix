{
  pkgs,
  home,
  ...
}: {
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
