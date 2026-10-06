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
    pkgs.xwayland-satellite
    pkgs.xdg-desktop-portal-gnome
    pkgs.libvterm
    pkgs.cmake
    pkgs.libtool
    pkgs.wl-clipboard
    pkgs.discord
    pkgs.taskwarrior3
    pkgs.taskwarrior-tui
    pkgs.postgresql
    pkgs.samba
    pkgs.git-cliff
    pkgs.tuigreet
    # swww
  ];

  # Login manager is now handled centrally in sddm.nix; SDDM will launch
  # the niri session via the desktop entry that programs.niri.enable
  # installs, so the old greetd/tuigreet block below is no longer needed.

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # NOTE: XDG_CURRENT_DESKTOP / XDG_SESSION_DESKTOP removed — they were
  # hardcoded to "niri" here, which would conflict with plasma.nix's
  # session setting them to "KDE". Each session now sets these itself.
  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
