{ self, lib }:
let
  inherit (builtins)
    attrNames attrValues elemAt hasAttr foldl' map readFile toString;
  inherit (lib) max pipe;
  inherit (self.lib) split-lines sum powers;

  inherit (import ./2-shared.nix { inherit self lib; }) parse-games;

  input = readFile ../inputs/2;

  example = ''
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  '';

  minimum-game = game:
    foldl' (acc: x:
      let
        colour = elemAt (attrNames x) 0;
        value = elemAt (attrValues x) 0;
      in if hasAttr colour acc then
        (acc // { ${colour} = max acc.${colour} value; })
      else
        acc // x) { } game.rounds;

  minimum-games = games: map minimum-game games;

  example-answer =
    pipe example [ split-lines parse-games minimum-games powers sum ];
  answer = pipe input [ split-lines parse-games minimum-games powers sum ];

in ''
  Answer was: ${toString answer}
  Example value result was: ${toString example-answer}
''
