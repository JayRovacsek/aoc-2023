# aoc-2023

This year I'll seek to equal progression of previous years. If I can achieve this I'll be pretty stoked as I'll be writing the solutions in nix.

## Why Nix?

Simply to keep exploring the language. Flakes are also a brilliant concept to provide a number of nice wrappers for the AOC that'll enable cross platform support (unix-like anyway)

## How?

Non-direnv/lorri method for day 1, solution 1:

```shell
nix run .#1-1
```

TOTO: below is not implemented just yet, will solve before AOC

Direnv/lorri method (assumed automatic run of `nix develop`) for day 1, solution 1:

```sh
1-1
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

## Build Status

If you're interested in the build status of the solutions, I've added a hydra project for aoc into my personal hydra instance.
You can check it out further [here](http://dragonite.lan:3000/jobset/aoc-2023/main) or I'll attempt to keep the below up to date.

Note that passing means the solution _builds_ not that it is correct. The half-implemented checks outputs should achieve this, I need more time to
complete that implementation

### Day 1

#### aarch64-linux

##### Part 1

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.aarch64-linux.1-1%2Fshield)

##### Part 2

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.aarch64-linux.1-2%2Fshield)

#### x86_64-linux

##### Part 1

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.x86_64-linux.1-1%2Fshield)

##### Part 2

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.x86_64-linux.1-2%2Fshield)

### Day 2

#### aarch64-linux

##### Part 1

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.aarch64-linux.2-1%2Fshield)

##### Part 2

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.aarch64-linux.2-2%2Fshield)

#### x86_64-linux

##### Part 1

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.x86_64-linux.2-1%2Fshield)

##### Part 2

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fjob%2Faoc-2023%2Fmain%2Fpackages.x86_64-linux.2-2%2Fshield)
