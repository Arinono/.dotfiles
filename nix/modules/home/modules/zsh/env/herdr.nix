{
  pkgs,
  herdr,
  ...
}: {
  herdr_sessionizer = pkgs.writeShellApplication {
    name = "herdr_sessionizer";
    runtimeInputs = [herdr pkgs.fzf pkgs.jq pkgs.toybox];

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

      existing=$(herdr workspace list --json 2>/dev/null | jq -r ".result.workspaces[] | select(.label == \"$selected_name\") | .workspace_id" | head -n 1)

      if [[ -n "$existing" ]]; then
        herdr workspace focus "$existing"
      else
        herdr workspace create --cwd "$selected" --label "$selected_name" --focus
      fi
    '';
  };

  herdr_kill_workspace = pkgs.writeShellApplication {
    name = "herdr_kill_workspace";
    runtimeInputs = [herdr];

    text = ''
      if [[ -z "''${HERDR_ACTIVE_WORKSPACE_ID}" ]]; then
        exit 1
      fi

      herdr workspace close "''${HERDR_ACTIVE_WORKSPACE_ID}"
    '';
  };
}
