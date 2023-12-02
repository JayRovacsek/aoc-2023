{ self, lib }:
let
  inherit (builtins)
    attrNames attrValues elemAt hasAttr foldl' map readFile toString;
  inherit (lib) drop toInt max pipe splitString;
  inherit (self.lib) flatten split-lines;

  input = readFile ../inputs/2;

  example = ''
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  '';

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

  parse-games = l: map parse-game l;

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

  powers = l: map (x: foldl' (acc: y: acc * y) 1 (attrValues x)) l;

  sum = l: foldl' (acc: x: x + acc) 0 l;

  example-answer =
    pipe example [ split-lines parse-games minimum-games powers sum ];
  answer = pipe input [ split-lines parse-games minimum-games powers sum ];

in ''
  Answer was: ${toString answer}
  Example value result was: ${toString example-answer}
''
