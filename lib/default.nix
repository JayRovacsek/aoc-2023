{ self, ... }:
let
  inherit (builtins) replaceStrings;
  inherit (self.inputs.nixpkgs) lib;

  flatten = a: builtins.foldl' (acc: x: acc ++ x) [ ] a;

  generate-days = n: builtins.genList (x: x + 1) n;
  generate-parts = generate-days;
  generate-solutions = days: parts:
    builtins.foldl' (acc: day:
      acc ++ (builtins.map
        (part: "${builtins.toString day}-${builtins.toString part}") parts)) [ ]
    days;

  is-numeric-literal = c: (builtins.match "[[:digit:]]+" c) == [ ];

  load-solutions = path: solutions:
    builtins.foldl' (acc: solution:
      let p = ./. + "${path}/${solution}.nix";
      in if builtins.pathExists p then
        (acc // { ${solution} = import p { inherit self lib; }; })
      else
        acc // { ${solution} = "Solution is missing"; }) { } solutions;

  parse-explicit-matches = with builtins;
    s: regex:
    map (x: filter (y: typeOf y == "string") x)
    (filter (x: typeOf x == "list") (split regex s));

  recurse-replace = from: to: s:
    let replacement = replaceStrings from to s;
    in if s == replacement then s else recurse-replace from to replacement;

  split-lines = with builtins;
    s:
    filter (x: typeOf x == "string" && x != "") (split "\n" s);

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
  inherit generate-days generate-parts generate-solutions flatten
    is-numeric-literal load-solutions parse-explicit-matches split-lines
    wrap-solutions recurse-replace;
}
