{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    olympus
    mangohud
    protonup-qt
  ];
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true; # For Steam Remote Play
    dedicatedServer.openFirewall = true; # For Source Dedicated Server hosting
    gamescopeSession.enable = true; # Integrates with programs.steam
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode.enable = true;
}
