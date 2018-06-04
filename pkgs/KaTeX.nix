{ stdenv, pkgs, ... }:

let
  katex-src = stdenv.mkDerivation rec {
    name = "katex-src";

    src = pkgs.fetchzip {
      url    = "https://github.com/Khan/KaTeX/releases/download/v0.10.0-alpha/katex.zip";
      sha256 = "002dzyf3wcyjxv4m6vv0v99gf82a9k7rxsnlvf93h9fhcda2vj7l";
    };

    buildInputs = [ pkgs.nodejs ];

    installPhase = ''
      mkdir -p $out/share/katex
      cp katex.min.js $out/share/katex/
    '';

    meta = {
      description = "KaTeX";
      homepage    = https://github.com/Khan/KaTeX;
      license     = stdenv.lib.licenses.mit;
      platforms   = stdenv.lib.platforms.all;
    };
  };
in pkgs.writeTextFile {
  name        = "katex-wrapper";
  executable  = true;
  destination = "/bin/katex";

  text = ''
    #!${pkgs.nodejs}/bin/node

    var katex = require("${katex-src}/share/katex/katex.min.js");
    var input = "";

    var args = process.argv.slice(2);

    process.stdin.on("data", function(chunk) {
        input += chunk.toString();
    });

    process.stdin.on("end", function() {
        var options = { displayMode: args.indexOf("--display-mode") !== -1 };
        var output = katex.renderToString(input, options);
        console.log(output);
    });
  '';
}
