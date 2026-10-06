{ pkgs, lib, ... }:
let
  # Not packaged in nixpkgs, so we build ToadKing's userspace driver from
  # source. It reads the Wii U/Mayflash GameCube adapter's proprietary USB
  # protocol and re-publishes each controller as a virtual uinput gamepad,
  # which is what makes the adapter usable in non-Dolphin games (Steam/Proton
  # titles like Rivals of Aether 2).
  wii-u-gc-adapter = pkgs.stdenv.mkDerivation {
    pname = "wii-u-gc-adapter";
    version = "0-unstable-2021-09-06";

    src = pkgs.fetchFromGitHub {
      owner = "ToadKing";
      repo = "wii-u-gc-adapter";
      rev = "fa098efa7f6b34f8cd82e2c249c81c629901976c";
      hash = "sha256-wm0vDU7QckFvpgI50PG4/elgPEkfr8xTmroz8kE6QMo=";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [
      pkgs.libusb1
      pkgs.udev
    ];

    # Upstream's Makefile passes -Wno-format, which conflicts with the
    # -Werror=format-security that NixOS's cc-wrapper injects. Turn off the
    # format hardening so the build succeeds.
    hardeningDisable = [ "format" ];

    installPhase = ''
      runHook preInstall
      install -Dm755 wii-u-gc-adapter $out/bin/wii-u-gc-adapter
      runHook postInstall
    '';

    meta = {
      description = "Userspace driver for the Wii U/Mayflash GameCube controller adapter";
      homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      mainProgram = "wii-u-gc-adapter";
    };
  };
in
{
  # The daemon creates its virtual gamepads through /dev/uinput.
  boot.kernelModules = [ "uinput" ];

  # Keep the binary on PATH for manual runs / debugging.
  environment.systemPackages = [ wii-u-gc-adapter ];

  # Correct GameCube button/axis layout for the daemon's virtual pad.
  # Physical wiring (from evtest): A=b0 B=b3 X=b1 Y=b2 Z=b6 Start=b7,
  #   D-pad b8-b11, left stick a0/a1, C-stick a3/a4, L/R analog a2/a5.
  # NOTE the deliberate cross-map b:b1 / x:b3 (NOT b:b3 / x:b1): Xbox-convention
  # games (Rivals of Aether 2 via Proton) read face buttons by POSITION, and GC
  # X sits in the east/"B" slot while GC B sits in the west/"X" slot. Mapping by
  # GameCube *label* flips them in-game; this positional map matches the Steam
  # Deck project. Use with Steam Input DISABLED so Proton's SDL applies it.
  environment.sessionVariables.SDL_GAMECONTROLLERCONFIG = "0300388e7e0500003703000000000000,GameCube Adapter,a:b0,b:b1,x:b3,y:b2,dpdown:b9,dpleft:b10,dpright:b11,dpup:b8,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b6,righttrigger:a5,rightx:a3,righty:a4,start:b7,platform:Linux,hint:!SDL_GAMECONTROLLER_USE_GAMECUBE_LABELS:=1,";

  # Grant the local session read/write on the virtual controllers the daemon
  # creates (replaces a manual `setfacl`). The primary user is in `users`.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{name}=="Wii U GameCube Adapter*", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

  # Deliberately NOT auto-started: the daemon claims the adapter exclusively
  # over USB, so it cannot coexist with Slippi/Dolphin's native adapter mode.
  # Toggle it per session:
  #   systemctl start wii-u-gc-adapter   # before Rivals of Aether 2 / Steam
  #   systemctl stop  wii-u-gc-adapter   # before launching Slippi
  systemd.services.wii-u-gc-adapter = {
    description = "Wii U/Mayflash GameCube adapter -> uinput virtual gamepads";
    serviceConfig = {
      ExecStart = lib.getExe wii-u-gc-adapter;
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
