# WebHID support for Chrome/Chromium browsers
#
# Allows the active user and members of the plugdev group to access HID
# devices (e.g. mice) through the WebHID API in Chromium/Chrome.
{
  config,
  lib,
  ...
}: {
  # Ensure the plugdev group exists.
  users.groups.plugdev = {};

  # Grant users in the plugdev group access to raw HID devices.
  # uaccess makes the device available to the active desktop user as well.
  services.udev.extraRules = ''
    # WebHID: allow access to hidraw devices
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess", GROUP="plugdev"
  '';
}
