with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = let
    InputXSLT = callPackage ./InputXSLT.nix {};
  in [
    InputXSLT
    pandoc
    highlight
    nodejs
    python3
  ];
}
