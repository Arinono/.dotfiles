{
  params,
  secrets,
  ...
}: {
  CustomUserPreferences = {
    "cc.ffitch.shottr" = {
      KeyboardShortcuts_area = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":21}";
      KeyboardShortcuts_fullscreen = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":20}";
      KeyboardShortcuts_window = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":23}";
      afterGrabCopy = 1;
      afterGrabSave = 1;
      afterGrabShow = 1;
      allowTelemetry = 0;
      alwaysOnTop = 1;
      areadCaptureMode = "preview";
      cmdQAction = "quit";
      colorFormat = "HEX";
      copyOnEsc = 1;
      saveOnEsc = 1;
      defaultFolder = "${params.home}/Downloads";
      downscaleOnSave = 0;
      expandableCanvas = 1;
      saveFormat = "PNG";
      windowShadow = "trimmed";
      showDockIcon = 1;
      showIntro = 0;
      showMenubarIcon = 1;
      thumbnailClosing = "auto";
      token = secrets.licenses.shottr;
    };
  };
}
