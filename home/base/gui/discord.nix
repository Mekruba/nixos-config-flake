{ pkgs, ... }:
{
  # vesktop needs an insecure pnpm; with home-manager.useGlobalPkgs that has to
  # be permitted system-side, in modules/nixos/base/insecure-packages.nix.
  home.packages = [ pkgs.vesktop ];
}
