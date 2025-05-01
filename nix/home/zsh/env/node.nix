{
  pkgs,
  home,
  ...
}: {
  aliases = with pkgs; {
    nr = "${nodejs}/bin/npm run";
    pnr = "${pnpm}/bin/pnpm run";
    ynr = "${yarn}/bin/yarn run";
  };

  path = [
    "${home}/Library/pnpm"
  ];
}
