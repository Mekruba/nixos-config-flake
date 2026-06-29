{ pkgs, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];
  home.packages = [ pkgs.vesktop ];
}
