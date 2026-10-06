{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      ll = "ls -alh";
      nd = "nix develop";
    };
  };

  # starship (enabled in ./starship) is wired into zsh automatically by
  # home-manager via programs.starship.enableZshIntegration (default true).
}
