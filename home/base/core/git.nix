{
  config,
  lib,
  pkgs,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  # home.packages = with pkgs; [
  # ];

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Magnus";
        email = "you@example.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      push.autoSetupRemote = true;
    };
  };
}
