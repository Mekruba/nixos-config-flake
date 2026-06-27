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
    lfs.enable = true;

    userName = "Mekruba";
    userEmail = "magnus.egeland@gmail.com";

    # includes = [
    #   {
    #     # use different email & name for work
    #     path = "~/work/.gitconfig";
    #     condition = "gitdir:~/work/";
    #   }
    # ];

    extraConfig = {
      init.defaultBranch = "main";
      # trim.bases = "develop,master,main"; # for git-trim
      push.autoSetupRemote = true;
      pull.rebase = true;
      github.user = "Mekruba";

      # host-specific override (matches the error message)
      "github \"api.github.com\"".user = "Mekruba";

    };
  };
}
