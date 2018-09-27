{ system ? builtins.currentSystem }:

let
  pkgs    = import <nixpkgs> { inherit system; };
  mypkgs  = import (fetchTarball "https://pkgs.kummerlaender.eu/nixexprs.tar.gz") { };

in pkgs.stdenv.mkDerivation rec {
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
