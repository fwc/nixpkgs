{ coq, mkCoqDerivation, mathcomp-analysis, lib, version ? null }:

mkCoqDerivation {
  namePrefix = [ "coq" "mathcomp" ];
  pname = "infotheo";
  owner = "affeldt-aist";
  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp-analysis.version] [
    { cases = [ (range "8.15" "8.16") (range "0.5.4" "0.6.2") ]; out = "0.5.1"; }
  ] null;
  release."0.5.1".sha256 = "sha256-yBBl5l+V+dggsg5KM59Yo9CULKog/xxE8vrW+ZRnX7Y=";

  propagatedBuildInputs = [ mathcomp-analysis ];

  meta = with lib; {
    description = "A Coq formalization of information theory and linear error-correcting codes";
    license = licenses.lgpl21Plus;
  };
}
