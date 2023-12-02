{ self, lib }:
let
  inherit (builtins) hasAttr foldl' map readFile elemAt attrNames attrValues;
  inherit (lib) drop max toInt splitString;
  inherit (self.lib) split-lines flatten;

  input = readFile ../inputs/2;

  example = ''
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  '';

  lines = split-lines input;

  # only 12 red cubes, 13 green cubes, and 14 blue cubes

  example-lines = split-lines example;

  parse-round = round:
    map (y:
      let sub-parts = splitString " " y;
      in { ${elemAt sub-parts 1} = toInt (elemAt sub-parts 0); }) round;

  parse-rounds = rounds:
    flatten (map (x: parse-round (splitString ", " x)) rounds);

  parse-game = l:
    let
      parts = flatten (map (x: splitString "; " x) (splitString ": " l));
      id = toInt (elemAt (splitString " " (elemAt parts 0)) 1);
      rounds = parse-rounds (drop 1 parts);
    in { inherit id rounds; };

  games = map parse-game lines;

  example-games = map parse-game example-lines;

  minimum-games = map (game:
    foldl' (acc: x:
      let
        colour = elemAt (attrNames x) 0;
        value = elemAt (attrValues x) 0;

      in if hasAttr colour acc then
        (acc // { ${colour} = max acc.${colour} value; })
      else
        acc // x) { } game.rounds) games;

  example-minimum-games = map (game:
    foldl' (acc: x:
      let
        colour = elemAt (attrNames x) 0;
        value = elemAt (attrValues x) 0;

      in if hasAttr colour acc then
        (acc // { ${colour} = max acc.${colour} value; })
      else
        acc // x) { } game.rounds) example-games;

  powers = map (x: foldl' (acc: y: acc * y) 1 (attrValues x)) minimum-games;

  example-powers =
    map (x: foldl' (acc: y: acc * y) 1 (attrValues x)) example-minimum-games;

  sum = foldl' (acc: x: x + acc) 0 powers;

  example-sum = foldl' (acc: x: x + acc) 0 example-powers;

in ''
  Answer was: ${builtins.toString sum}
  Example value result was: ${builtins.toString example-sum}
''
