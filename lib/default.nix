{ self, ... }:
with builtins;
with self.inputs.nixpkgs.lib;
let inherit (self.inputs.nixpkgs) lib;
in rec {
  flatten = a: foldl' (acc: x: acc ++ x) [ ] a;

  generate-days = n: genList (x: x + 1) n;

  generate-parts = generate-days;

  generate-solutions = days: parts:
    foldl'
    (acc: day: acc ++ (map (part: "${toString day}-${toString part}") parts))
    [ ] days;

  is-numeric-literal = c: (match "[[:digit:]]+" c) == [ ];

  load-solutions = path: solutions:
    foldl' (acc: solution:
      let p = ./. + "${path}/${solution}.nix";
      in if pathExists p then
        (acc // { ${solution} = import p { inherit self lib; }; })
      else
        acc // { ${solution} = "Solution is missing"; }) { } solutions;

  parse-explicit-matches = s: regex:
    map (x: filter (y: typeOf y == "string") x)
    (filter (x: typeOf x == "list") (split regex s));

  powers = l: map (x: foldl' (acc: y: acc * y) 1 (attrValues x)) l;

  recurse-replace = from: to: s:
    let replacement = replaceStrings from to s;
    in if s == replacement then s else recurse-replace from to replacement;

  split-lines = s: filter (x: typeOf x == "string" && x != "") (split "\n" s);

  sum = l: foldl' (acc: x: x + acc) 0 l;

  wrap-solutions = pkgs:
    foldlAttrs (acc: name: _:
      let
        bin = pkgs.writeShellScriptBin name ''
          ${pkgs.nix}/bin/nix eval ${self}#common.solutions."${name}"
        '';
        pname = name;
        version = if hasAttr "rev" self.outputs.self then
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
}
