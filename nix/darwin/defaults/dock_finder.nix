{
  pkgs,
  params,
  ...
}: {
  base = {
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file://${params.home}/Downloads";
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = false;
      _FXShowPosixPathInTitle = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.25;
      expose-animation-duration = 0.0;
      expose-group-apps = true;
      orientation = "right";
      mineffect = "scale";
      launchanim = false;
      tilesize = 32;
      magnification = false;
      minimize-to-application = true;
      mru-spaces = false;
      persistent-apps = [
        {
          app = "/Applications/Ghostty.app";
        }
        {
          app = "${pkgs.spotify}/Applications/Spotify.app";
        }
      ];
      persistent-others = [
        "${params.home}/Downloads"
      ];
      show-recents = false;
      showhidden = true;
      slow-motion-allowed = false;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };
  };

  CustomSystemPreferences = {
    finder = {
      DisableAllAnimations = true;
      FK_ArrangeBy = "Date Added";
      FK_SidebarWidth = 150;
      FXArrangeGroupViewBy = "Name";
      FXLastSearchScope = "SCcf";
      FXPreferredGroupBy = "Name";
      FXPreferredSearchViewStyle = "Nlsv";
      RecentsArrangeGroupViewBy = "Date Last Opened";
      ShowSidebar = true;
      SidebarDevicesSectionDisclosedState = true;
      SidebarPlacesSectionDisclosedState = true;
      SidebarShowingSignedIntoiCloud = true;
      SidebarTagsSectionDisclosedState = false;
      SidebariCloudDriveSectionDisclosedState = true;
    };
  };
}
