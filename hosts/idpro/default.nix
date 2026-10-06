{
  lib,
  config,
  pkgs,
  username,
  nixos-hardware,
  ...
}:

{
  imports = [
    ../../modules/nixos/client
    # ../../modules/nixos/client/niri.nix
    ../../modules/nixos/client/plasma.nix
    ../../modules/nixos/client/sddm.nix
    # ../../modules/nixos/client/dms.nix
    ../../modules/nixos/client/steam.nix
    # ../../modules/nixos/base/amd.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];

  # Use zsh as the default login shell on idpro.
  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    systemd-boot.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

  services.openssh.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    # sudo.u2fAuth = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  networking.hostName = "IP-P5"; # Define your hostname.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4200
      5063
    ];
  };

  networking.networkmanager.enable = true;

  system.stateVersion = "24.05";
}
