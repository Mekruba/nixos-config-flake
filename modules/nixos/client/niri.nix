{
  pkgs,
  inputs,
  config,
  lib,
  username,
  ...
}:
{
  environment.systemPackages = [
    pkgs.fuzzel
    # quickshell
    pkgs.xwayland-satellite
    pkgs.xdg-desktop-portal-gnome
    pkgs.flameshot
    pkgs.mako
    pkgs.libvterm
    pkgs.cmake
    pkgs.libtool
    pkgs.wl-clipboard
    pkgs.hyprlock
    pkgs.cliphist
    pkgs.swaylock
    pkgs.discord
    pkgs.taskwarrior3
    pkgs.taskwarrior-tui
    pkgs.postgresql
    pkgs.samba
    pkgs.git-cliff
    pkgs.tuigreet
    # swww
  ];
  # If Niri is now managed by Home Manager, start the HM session wrapper:
  # services.greetd = {
  #   enable = true;
  #   settings.default_session = {
  #     user = username;
  #     command = "niri-session"; # HM generates this
  #     # command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
  #     # or: "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session"
  #   };
  # };

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # for gtk
      xdg-desktop-portal-gnome
      kdePackages.xdg-desktop-portal-kde
      # xdg-desktop-portal-kde  # for kde
    ];
  };
  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "gnome";
    XDG_SESSION_DESKTOP = "niri";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
