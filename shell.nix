{ pkgs ? import <nixpkgs> { }, mypkgs ? import <mypkgs> { }, ... }:

pkgs.stdenv.mkDerivation rec {
  name = "blog.kummerlaender.eu";

  buildInputs = [
    pkgs.pandoc
    pkgs.highlight
    mypkgs.katex-wrapper
    mypkgs.make-xslt
  ];

  shellHook = ''
    export NIX_SHELL_NAME="${name}"
  '';
}
