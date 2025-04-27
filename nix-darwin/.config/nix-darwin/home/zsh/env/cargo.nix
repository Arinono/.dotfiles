{pkgs, ...}:
with pkgs; {
  path = [
    "$HOME/.cargo/bin"
  ];

  variables = {
    CARGO_NET_GIT_FETCH_WITH_CLI = true;
    RUST_WRAPPER = "sccache";
    WASM_PACK_PATH = wasm-pack;
  };
}
