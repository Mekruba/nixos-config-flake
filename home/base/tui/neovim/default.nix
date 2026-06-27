{ config, pkgs, ... }:
{
  # programs.neovim = {
  #   enable = true;
  # };
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/magnus/repos/nixos-config-flake/home/base/tui/neovim/nvim;
    recursive = true;
  };
}
