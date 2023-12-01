{ self, pkgs, ... }:
let
  inherit (pkgs) system;
  own-packages = self.packages.${system};
in {
  check-1-1 = pkgs.stdenvNoCC.mkDerivation {
    name = "day-one-check";
    dontBuild = true;
    src = self;
    phases = [ "checkPhase" "installPhase" ];
    checkPhase = ''
      $(${own-packages."1-1"}/bin/1-1) == \"43\";
      exit $?"
    '';
    installPhase = ''
      mkdir "$out"
    '';
  };
}
