{ pkgs, ... }:

let
  InputXSLT  = pkgs.callPackage ./InputXSLT.nix {};
  StaticXSLT = pkgs.callPackage ./StaticXSLT.nix {};
  BuildXSLT  = pkgs.callPackage ./BuildXSLT.nix {};
in pkgs.writeScriptBin
  "generate"
  ''
    #!/bin/sh
    ${InputXSLT}/bin/ixslt --input make.xml --transformation ${BuildXSLT}/build.xsl --include ${StaticXSLT}/
  ''
