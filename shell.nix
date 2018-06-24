with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "blog-env";
  env = buildEnv { name = name; paths = buildInputs; };

  buildInputs = let
    generate  = pkgs.callPackage ./pkgs/generate.nix {};
    preview   = pkgs.callPackage ./pkgs/preview.nix {};
    katex     = pkgs.callPackage ./pkgs/KaTeX.nix {};
  in [
    generate
    preview
    pandoc
    highlight
    katex
  ];
}
