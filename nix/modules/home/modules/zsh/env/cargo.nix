{
  pkgs,
  home,
  ...
}: {
  path = [
    "${home}/.cargo/bin"
  ];

  variables = with pkgs; {
    CARGO_NET_GIT_FETCH_WITH_CLI = true;
    RUST_WRAPPER = pkgs.sccache;
    WASM_PACK_PATH = wasm-pack;
  };
}
