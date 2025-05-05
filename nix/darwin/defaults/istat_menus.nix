{secrets, ...}: {
  CustomUserPreferences = {
    "com.bjango.istatmenus.menubar.7" = {
      License.License = secrets.licenses.istatmenus.version7;
      Menu.Theme.Dark = "system";
      Menubar = {
        Global.ReducePadding = 0;
        Theme.Dark = "custom";
      };
      Sensors.Global.DetailLevel = 1;

      Combined.Menu.Items = [
        "cpu-uptime"
        "cpu-cpu"
        "memory-overview"
        "disks-physical"
        "network-bandwidth"
        "sensors-overview"
        "battery-combined"
        "battery-bluetooth"
      ];

      Profiles.Settings.default = {
        Battery.Menubar.Enabled = 0;
        CPU.Menubar.Enabled = 0;
        Disks.Menubar.Enabled = 0;
        Memory.Menubar.Enabled = 0;
        Network.Menubar.Enabled = 0;
        Sensors.Menubar.Enabled = 0;
        Combined.Menubar = {
          Enabled = 1;
          Items = [
            {
              source = 1;
              subtype = 1;
              type = 3;
            }
            {
              source = 2;
              type = 3;
            }
            {
              source = 3;
              type = 3;
            }
            {
              source = 7;
              subtype = 6;
              type = 7;
            }
          ];
        };
      };
    };
  };
}
