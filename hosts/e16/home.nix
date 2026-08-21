{ pkgs, ... }:
{
  imports = [
    ../../home/gui.nix
    ../../home/work
  ];
  
  home.shellAliases = {};
  programs.zsh.defaultKeymap = "emacs";
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
  
  home.file.".config/niri/output.kdl" = {
    source = ./niri/output.kdl;
  };
}
