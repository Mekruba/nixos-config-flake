{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    papirus-icon-theme

    libsForQt5.qt5ct
  ];
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  environment.sessionVariables = {
    XCURSOR_THEME = "Papirus-Dark";
  };
}
