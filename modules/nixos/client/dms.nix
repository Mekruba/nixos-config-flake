{ ... }:
{
  programs.dank-material-shell.enable = true;
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri"; # Or "hyprland" or "sway"
  };
}
