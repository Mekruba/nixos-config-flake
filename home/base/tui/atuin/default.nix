{ ... }:
{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };
  home.file.".config/atuin" = {
    source = ./config;
    recursive = true; # link recursively
    executable = true; # make all files executable
  };
}
