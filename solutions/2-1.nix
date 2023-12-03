{ self, lib }:
let
  inherit (builtins) attrValues attrNames all elemAt filter foldl' readFile;
  inherit (lib) pipe;
  inherit (self.lib) split-lines;

  inherit (import ./2-shared.nix { inherit self lib; }) parse-games;
  input = readFile ../inputs/2;

  example = ''
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  '';

  rule-set = {
    red = 12;
    green = 13;
    blue = 14;
  };

  example-answer = pipe example [
    split-lines
    parse-games
    (filter (game:
      all (round:
        let
          colour = elemAt (attrNames round) 0;
          value = elemAt (attrValues round) 0;
        in value <= rule-set.${colour}) game.rounds))
    (foldl' (acc: game: game.id + acc) 0)
  ];

  answer = pipe input [
    split-lines
    parse-games
    (filter (game:
      all (round:
        let
          colour = elemAt (attrNames round) 0;
          value = elemAt (attrValues round) 0;
        in value <= rule-set.${colour}) game.rounds))
    (foldl' (acc: game: game.id + acc) 0)
  ];

in ''
  Answer was: ${builtins.toString answer}
  Example value result was: ${builtins.toString example-answer}
''
