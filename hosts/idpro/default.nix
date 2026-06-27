# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    ../../modules/nixos/client
    ../../modules/nixos/client/niri.nix
    ../../modules/nixos/client/dms.nix
    ../../modules/nixos/client/steam.nix
    ../../modules/nixos/base/amd.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    systemd-boot.enable = true;
    # grub = {
    #   enable = true;
    #   device = "nodev";  #  "nodev"
    #   efiSupport = true;
    #   # useOSProber = true;
    #   #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    # };
  };

  hardware.opengl = {
    enable = true;
  };
  hardware.cpu.amd.ryzen-smu.enable = true;

  services.openssh.enable = true;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  services.power-profiles-daemon.enable = true;

  networking.hostName = "IP-P5"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";
  # networking.defaultGateway = "192.168.5.201";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
