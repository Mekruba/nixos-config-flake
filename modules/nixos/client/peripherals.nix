{ pkgs, ... }:
{
  #============================= Audio(PipeWire) =======================

  environment.systemPackages = with pkgs; [
    pulseaudio # provides `pactl`, which is required by some apps(e.g. sonic-pi)
  ];
  programs.noisetorch.enable = true;

  services.pipewire = {
    enable = true;
    # package = pkgs-unstable.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # Disable pulseaudio, it conflicts with pipewire too.
  hardware.pulseaudio.enable = false;

  #============================= Bluetooth =============================

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #================================= Misc =================================

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tailscale.enable = true;

  services = {
    printing.enable = true; # Enable CUPS to print documents.
    geoclue2.enable = true; # Enable geolocation services.

    udev.packages = with pkgs; [
      # gnome-settings-daemon
      platformio # udev rules for platformio
      openocd # required by paltformio, see https://github.com/NixOS/nixpkgs/issues/224895
      qmk-udev-rules
    ];
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="102b", MODE="0666"
    '';
    # udev.extraRules = ''
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # '';
  };
}
