{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "remind";
    runtimeInputs = [pkgs.timer pkgs.terminal-notifier];

    text = ''
      if [[ -z $1 ]]; then
        echo "Usage: remind <message>"
        return 1
      fi

      if [[ -z $2 ]]; then
        echo "Usage: remind <message> <time>"
        return 1
      fi

      timer "$2" --name "$1" && terminal-notifier -sender com.apple.terminal \
      -message "$1" \
      -title "Reminder" \
      -sound Crystal
    '';
  };
}
