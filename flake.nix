{
  description = "static site generator for blog.kummerlaender.eu";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
    pkgs-personal.url = git+https://code.kummerlaender.eu/pkgs;
  };

  outputs = { self, nixpkgs, pkgs-personal, ... }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = [
        pkgs.pandoc
        pkgs.highlight
        pkgs-personal.katex-wrapper
        pkgs-personal.make-xslt
      ];
    };

    generate = content: pkgs.stdenv.mkDerivation {
      name = "blog.kummerlaender.eu";

      src = ./.;

      LANG = "en_US.UTF-8";

      buildInputs = [
        pkgs.pandoc
        pkgs.highlight
        pkgs-personal.katex-wrapper
        pkgs-personal.make-xslt
      ];

      installPhase = ''
        cp -r ${content} source/00_content
        make-xslt
        mkdir $out
        cp -Lr target/99_result/* $out
      '';
    };
  };
}
