{isDarwin, ...}: {
  aliases =
    if isDarwin
    then {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    }
    else {};
}
