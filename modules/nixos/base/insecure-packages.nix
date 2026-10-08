{
  nixpkgs.config.permittedInsecurePackages = [
    # required by vesktop (see home/base/gui/discord.nix); set here because
    # home-manager.useGlobalPkgs makes the per-user `nixpkgs.*` options a no-op.
    "pnpm-10.29.2"
    # required by wechat-uos:
    # "openssl-1.1.1w"
  ];
}
