{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "BuildXSLT";

  src = fetchFromGitHub {
    owner = "KnairdA";
    repo = "BuildXSLT";
    rev = "master";
    sha256 = "09kxhvhzn0r62l39zgj1kc21rb565fnc1y3sg48p4gi4v15xjmc6";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = with stdenv.lib; {
    description = "BuildXSLT";
    homepage    = https://github.com/KnairdA/BuildXSLT/;
    license     = stdenv.lib.licenses.mit;
  };
}
