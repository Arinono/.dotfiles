{...}: {
  system.activationScripts.postActivation.text = ''
    echo "Enabling firewall"
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  '';
}
