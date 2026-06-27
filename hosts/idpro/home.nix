{ ... }:
{
  imports = [
    ../../home/gui.nix
    ../../home/work
  ];
  home.file.".config/niri/output.kdl" = {
    source = ./niri/output.kdl;
  };
}
