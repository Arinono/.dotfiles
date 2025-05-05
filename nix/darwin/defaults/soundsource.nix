{secrets, ...}: {
  CustomUserPreferences = {
    "com.rogueamoeba.soundsource" = {
      dontAskLaunchAtLogin = 1;
      hasRemovedHideAtLogin = 1;
      keyboardVolume = 1;
      registrationInfo = {
        Code = secrets.licenses.soundsource.version5.code;
        Name = secrets.licenses.soundsource.version5.name;
      };
    };
  };
}
