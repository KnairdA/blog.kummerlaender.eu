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

      shellHook = ''
        export NIX_SHELL_NAME="blog.kummerlaender.eu"
      '';
    };
  };
}
