{ self, lib }:
let inherit (self.lib) flatten;
in with lib;
with builtins; rec {
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

  filter-games = f: games: (filter (game: all f game.rounds) games);
}
