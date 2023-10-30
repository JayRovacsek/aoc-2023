{
  description = "AoC 2023";

  # All inputs are included to apply "follows abuse" to all
  # needed and transitive inputs. That way we're not downloading
  # multiple copies of the same repository for no real benefit.
  inputs = {
    # Transitive input
    crane = {
      url = "github:ipetkov/crane";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Required to wrap shell outputs nicely
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };

    # Required to simplify structure
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    pre-commit-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/pre-commit-hooks.nix";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      standard-outputs = {
        inherit self;

        common = import ./common { inherit self; };
        lib = import ./lib { inherit self; };
      };

      flake-parts-outputs = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import self.inputs.nixpkgs { inherit system; };
          tests = import ./tests { inherit pkgs self; };
        in {
          apps.nixci-run = {
            program = builtins.toString (pkgs.writers.writeBash "run-nixci" ''
              ${pkgs.nixci}/bin/nixci
            '');

            type = "app";
          };

          # Space in which exposed derivations can be ran via
          # nix run .#foo - handy in the future for stuff like deploying
          # via terraform or automation tasks that are relatively 
          # procedural 
          # apps = import ./apps { inherit self pkgs; };

          # Pre-commit hooks to enforce formatting, lining, find 
          # antipatterns and ensure they don't reach upstream
          checks = tests // {
            pre-commit = self.inputs.pre-commit-hooks.lib.${system}.run {
              src = self;
              hooks = {
                # Builtin hooks
                deadnix.enable = true;
                nixfmt.enable = true;
                prettier.enable = true;
                statix.enable = true;

                # Custom hooks
                statix-write = {
                  enable = true;
                  name = "Statix Write";
                  entry = "${pkgs.statix}/bin/statix fix";
                  language = "system";
                  pass_filenames = false;
                };
              };

              settings = {
                deadnix.edit = true;
                nixfmt.width = 80;
                prettier.write = true;
              };
            };
          };

          # Shell environments (applied to both nix develop and nix-shell via
          # shell.nix in top level directory)
          devShells.default = pkgs.mkShell {
            name = "aoc-dev-shell";
            packages = with pkgs; [ nixfmt ];
            inherit (self.checks.${system}.pre-commit) shellHook;
          };

          # Formatter option for `nix fmt` - redundant via checks but nice to have
          formatter = pkgs.nixfmt;

          # Locally defined packages for flake consumption or consumption
          # on the nur via: pkgs.nur.repos.JayRovacsek if utilising the nur overlay
          # (all systems in this flake apply this opinion via the common.modules)
          # construct
          packages = self.outputs.lib.wrap-solutions pkgs;
          #   self.outputs.common.solutions;
          # import ./packages { inherit self pkgs; };
        });
    in standard-outputs // flake-parts-outputs;
}
