{ self, lib }:
let
  inherit (lib) filterAttrs mapAttrs;

  unsupported-systems = [ "aarch64-darwin" "x86_64-darwin" ];
  # Strip out unsupportable systems.
  supported-packages = builtins.removeAttrs self.packages unsupported-systems;

  # Strip broken & unsupported packages as they just cause eval errors
  non-broken-packages = mapAttrs (_: value:
    filterAttrs (_: v: (!v.meta.broken && !v.meta.unsupported)) value)
    supported-packages;
in {
  checks = removeAttrs self.checks unsupported-systems;
  devShells = removeAttrs self.devShells unsupported-systems;
  packages = non-broken-packages;
}
