{
  home,
  pkgs,
  ...
}: {
  variables = {
    # DART_SDK = "${pkgs.dart.sdk}";
  };

  path = [
    "${home}/.pub-cache/bin"
  ];
}
