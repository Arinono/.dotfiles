{
  username,
  pkgs,
  ...
}: {
  variables = {
    # DART_SDK = "${pkgs.dart.sdk}";
  };

  path = [
    "/Users/${username}/.pub-cache/bin"
  ];
}
