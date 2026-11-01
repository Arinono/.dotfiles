{home, ...}: {
  path = [
    "${home}/.go/bin"
  ];

  variables = {
    GOPATH = "${home}/.go";
  };
}
