{ pkgs, ... }:

{
  # Nautilus (GNOME Files) + zip/unzip support via file-roller.
  #
  # nautilus needs its GNOME "services" (Tracker, gvfs, etc.) to behave well
  # standalone outside a full GNOME session — this pulls those in properly
  # instead of just dumping the binary in systemPackages.
  services.gvfs.enable = true; # trash, mtp, network mounts, "Open With" etc.
  services.tumbler.enable = true; # thumbnails for images/videos in the file view

  environment.systemPackages = with pkgs; [
    nautilus
    file-roller # gives Nautilus "Extract Here" / "Compress..." in the right-click menu
    gnome-tweaks # optional, remove if you don't want it

    # backends file-roller shells out to for actually (de)compressing archives
    unzip
    zip
    p7zip
    unrar
  ];
}
