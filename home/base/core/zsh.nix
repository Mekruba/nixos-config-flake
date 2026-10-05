{ pkgs, lib, ... }:
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

    # any-nix-shell wraps `nix-shell` and `nix shell` so they drop you into
    # zsh instead of bash. `nix develop` is not covered (use `nd` or direnv).
    initContent = lib.mkOrder 1200 ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };

  # starship (enabled in ./starship) is wired into zsh automatically by
  # home-manager via programs.starship.enableZshIntegration (default true).

  programs.carapace.enable = true;
  programs.carapace.enableZshIntegration = true;
  programs.carapace.enableBashIntegration = true;

  programs.tmux.extraConfig = ''
    set-option -g default-shell ${pkgs.zsh}/bin/zsh
  '';
}
