{params, ...}: {
  hitoolbox = {
    AppleFnUsageType = "Do Nothing";
  };

  menuExtraClock = {
    FlashDateSeparators = false;
    IsAnalog = false;
    Show24Hour = true;
    ShowAMPM = false;
    ShowDate = 0;
    ShowDayOfMonth = true;
    ShowDayOfWeek = true;
    ShowSeconds = false;
  };

  screencapture = {
    disable-shadow = true;
    include-date = true;
    location = "${params.home}/Downloads";
    show-thumbnail = true;
    target = "file";
    type = "jpg";
  };

  screensaver = {
    askForPassword = true;
    askForPasswordDelay = 0;
  };

  smb = {
    NetBIOSName = params.hostname;
  };

  spaces.spans-displays = true;

  CustomSystemPreferences = {
    "com.apple.airplay".showInMenuBarIfPresent = 0;

    hitoolbox = {
      AppleDictationAutoEnable = 0;
    };
  };

  CustomUserPreferences = {
    "com.apple.Accessibility" = {
      KeyRepeatDelay = 0.5;
      KeyRepeatEnabled = 1;
      KeyRepeatInterval = 0.033;
      ReduceMotionEnabled = 1;
    };

    "com.apple.TextEdit".RichText = 0;
  };
}
