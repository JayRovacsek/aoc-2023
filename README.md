# aoc-2023

This year I'll seek to equal progression of previous years. If I can achieve this I'll be pretty stoked as I'll be writing the solutions in nix.

## Why Nix?

Simply to keep exploring the language. Flakes are also a brilliant concept to provide a number of nice wrappers for the AOC that'll enable cross platform support (unix-like anyway)

## How?

Non-direnv/lorri method for day 1, solution 1:

```shell
nix run .#solution-1-1
```

Direnv/lorri method (assumed automatic run of `nix develop`) for day 1, solution 1:

```sh
solution-1-1
```

Replace `1-1` with `$DAY-$PART` for other options, note that the package
for each day will dynamically be loaded for each solution

## REPL

To debug and toy with solutions more interactively, use the repl:

```sh
nix repl
:lf .
```

From here you should be able to inspect all outputs of the flake as per
normal.
