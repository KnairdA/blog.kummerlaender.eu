{ pkgs, ... }:

pkgs.writeScriptBin
  "preview"
  ''
    #!/bin/sh
    pushd target/99_result
    ${pkgs.python3}/bin/python -m http.server 8080
    popd
  ''
