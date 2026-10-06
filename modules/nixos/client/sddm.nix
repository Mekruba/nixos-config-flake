{ pkgs, ... }:
{
  # Shared login manager for both the niri and plasma6 sessions.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # theme = "breeze";
  };

  # Leave unset to let SDDM remember the last session you picked.
  # Set explicitly if you want a fixed default instead:
  # services.displayManager.defaultSession = "plasma"; # or "niri"
}
