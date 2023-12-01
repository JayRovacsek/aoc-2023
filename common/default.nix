{ self, ... }:
let
  inherit (self) lib;
  days = lib.generate-days 25;
  parts = lib.generate-parts 2;
  solution-identifiers = lib.generate-solutions days parts;

  solutions = lib.load-solutions "/../solutions" solution-identifiers;

in { inherit days parts solutions; }
