{ pkgs, ... }:
{
  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        nd = "nix develop -c nu";
      };
      extraConfig = ''
        $env.config.show_banner = false
      '';
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
    carapace.enableBashIntegration = true;
    tmux.extraConfig = ''
      set-option -g default-shell ${pkgs.nushell}/bin/nu
    '';

  };
}
