{ slippi, ... }:
{
  imports = [
    # Provides the GameCube USB adapter setup:
    #   - boot.extraModulePackages = gcadapter-oc-kmod (overclock)
    #   - boot.kernelModules = [ "gcadapter_oc" ]
    #   - services.udev.extraRules for vendor 057e:0337 (uaccess)
    # All options default to `true`, so importing is enough.
    slippi.nixosModules.default
  ];

  environment.systemPackages = [
    slippi.packages.x86_64-linux.default
  ];
}
