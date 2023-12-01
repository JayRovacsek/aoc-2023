{ self, lib }:
let
  inherit (builtins) filter foldl' head map toString readFile;
  inherit (lib) last stringToCharacters toInt range zipLists;
  inherit (self.lib) recurse-replace split-lines is-numeric-literal;

  input = readFile ../inputs/1;

  example = ''
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
  '';

  numeric-literals =
    [ "zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" ];

  numeric-exacts = range 0 9;

  numeric-map = zipLists numeric-literals numeric-exacts;

  numeric-replacements =
    map (n: "${toString n.snd}${last (stringToCharacters n.fst)}") numeric-map;

  lines =
    split-lines (recurse-replace numeric-literals numeric-replacements input);

  example-lines =
    split-lines (recurse-replace numeric-literals numeric-replacements example);

  numbers =
    map (line: (filter is-numeric-literal (stringToCharacters line))) lines;

  example-numbers =
    map (line: (filter is-numeric-literal (stringToCharacters line)))
    example-lines;

  calibration-values =
    map (numbers: toInt "${head numbers}${last numbers}") numbers;

  example-calibration-values =
    map (numbers: toInt "${head numbers}${last numbers}") example-numbers;

  sum = foldl' (acc: x: acc + x) 0 calibration-values;

  example-sum = foldl' (acc: x: acc + x) 0 example-calibration-values;

in ''
  Answer was: ${builtins.toString sum}
  Example value result was: ${builtins.toString example-sum}
''
