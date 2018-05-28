{ stdenv, fetchFromGitHub, cmake, boost, xalanc, xercesc, discount }:

stdenv.mkDerivation rec {
  name = "InputXSLT";

  src = fetchFromGitHub {
    owner = "KnairdA";
    repo = "InputXSLT";
    rev = "master";
    sha256 = "1j9fld3sh1jyscnsx6ab9jn5x6q67rjh9p3bgsh5na1qrs40dql0";
  };

  buildInputs = [ cmake boost xalanc xercesc discount ];

  meta = with stdenv.lib; {
    description = "InputXSLT";
    homepage    = https://github.com/KnairdA/InputXSLT/;
    license     = stdenv.lib.licenses.asl20;
  };
}
