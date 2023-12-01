{ self, lib }:
let
  inherit (builtins) filter foldl' head map readFile;
  inherit (lib) last stringToCharacters toInt;
  inherit (self.lib) split-lines is-numeric-literal;

  input = readFile ../inputs/1;

  example = ''
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  '';

  lines = split-lines input;

  example-lines = split-lines example;

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
