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
    pkgs.wl-clipboard
    pkgs.discord
    pkgs.taskwarrior3
    pkgs.taskwarrior-tui
    pkgs.postgresql
    pkgs.samba
    pkgs.git-cliff
    pkgs.kdePackages.kate
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.ark
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.kdeconnect-kde
    pkgs.kdePackages.plasma-systemmonitor
  ];

  # Plasma 6 desktop, run under Wayland (login manager is sddm.nix).
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # NOTE: no XDG_CURRENT_DESKTOP / XDG_SESSION_DESKTOP here on purpose —
  # each session (niri-session vs. plasma) sets these itself. Hardcoding
  # them globally would conflict with niri.nix's values.
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

  security.polkit.enable = true;

  # KDE uses KWallet, not gnome-keyring; unlock it automatically at SDDM login.
  security.pam.services.sddm.enableKwallet = true;

  programs.kdeconnect.enable = true;
  # networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  # networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
}
