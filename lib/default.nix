{ self, ... }:
let
  inherit (self.inputs.nixpkgs) lib;

  generate-days = n: builtins.genList (x: x + 1) n;
  generate-parts = generate-days;
  generate-solutions = days: parts:
    builtins.foldl' (acc: day:
      acc ++ (builtins.map
        (part: "${builtins.toString day}-${builtins.toString part}") parts)) [ ]
    days;

  load-solutions = path: solutions:
    builtins.foldl' (acc: solution:
      let p = ./. + "${path}/${solution}.nix";
      in if builtins.pathExists p then
        (acc // { ${solution} = import p; })
      else
        acc // { ${solution} = "Solution is missing"; }) { } solutions;

  wrap-solutions = pkgs:
    lib.foldlAttrs (acc: name: _:
      let
        bin = pkgs.writeShellScriptBin name ''
          ${pkgs.nix}/bin/nix eval ${self}#common.solutions."${name}"
        '';
        pname = name;
        version = if builtins.hasAttr "rev" self.outputs.self then
          self.outputs.self.rev
        else
          self.outputs.self.dirtyRev;
      in acc // {
        ${name} = pkgs.stdenvNoCC.mkDerivation {
          inherit pname version;

          buildInputs = [ bin ];
          phases = [ "installPhase" "fixupPhase" ];
          installPhase = ''
            mkdir -p $out/bin
            ln -s ${bin}/bin/${name} $out/bin
          '';
        };

      }) { } self.common.solutions;

in {
  inherit generate-days generate-parts generate-solutions load-solutions
    wrap-solutions;
}
