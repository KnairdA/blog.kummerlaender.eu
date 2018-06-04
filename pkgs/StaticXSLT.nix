{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "StaticXSLT";

  src = fetchFromGitHub {
    owner = "KnairdA";
    repo = "StaticXSLT";
    rev = "master";
    sha256 = "17gd181cw9yyc4h1fn7fikcgm8g7fdwm7d7fxwib4aynm18kwqad";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = with stdenv.lib; {
    description = "StaticXSLT";
    homepage    = https://github.com/KnairdA/StaticXSLT/;
    license     = stdenv.lib.licenses.mit;
  };
}
