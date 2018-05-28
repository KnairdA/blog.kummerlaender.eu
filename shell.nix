with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = let
    InputXSLT = callPackage ./pkgs/InputXSLT.nix {};
    KaTeX     = callPackage ./pkgs/KaTeX.nix {};
  in [
    InputXSLT
    pandoc
    highlight
    KaTeX
    python3
  ];
}
