{
  lib,
  ...
}:
{
  # to install chrome, you need to enable unfree packages
  nixpkgs.config.allowUnfree = lib.mkForce true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "monthly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  nix.settings = {
    # Required by nix-direnv: the .direnv gcroot only pins the dev shell's
    # top-level env, so without these the GC still reaps the derivation and
    # the build inputs behind it. The symptoms are a dev shell whose binaries
    # vanish mid-session ("command not found" after you exit a program) and
    # direnv re-evaluating the shell from scratch instead of using its cache.
    keep-outputs = true;
    keep-derivations = true;

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
}
