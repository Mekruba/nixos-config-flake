{ ... }:
{
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
    };
  };

  # The greeter lives in its own flake now (inputs.dank-greeter); it used to be
  # programs.dank-material-shell.greeter.
  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/magnus";
  };

  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
