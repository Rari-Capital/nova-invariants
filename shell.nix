let
  pkgs = import (builtins.fetchGit rec {
    name = "dapptools-${rev}";
    url = https://github.com/dapphub/dapptools;
    rev = "b8958a0f01f8f2bde0b489e9793e86e3a8f9a044";
  }) {};

in
  pkgs.mkShell {
    src = null;
    name = "rari-capital-nova-invariants";
    buildInputs = with pkgs; [
      pkgs.dapp
    ];
  }