{
  description = "Ove Nixos Config";

  # outputs = inputs: import ./outputs inputs;

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.11";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wsl stuff
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nixos-wsl,
      lanzaboote,
      nix-ld,
      dms,
      ...
    }:
    {
      nixosConfigurations = {
        gpc =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/gpc
              nix-ld.nixosModules.nix-ld

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.backupFileExtension = "backup";
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                home-manager.users.${username} = {
                  imports = [
                    (import ./hosts/gpc/home.nix)
                  ];
                };
              }
            ];
          };
        sp6 =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/sp6
              nix-ld.nixosModules.nix-ld
              nixos-hardware.nixosModules.microsoft-surface-pro-intel

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.backupFileExtension = "backup";
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./hosts/gpc/home.nix;
              }
            ];
          };
        t14s =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/t14s
              nix-ld.nixosModules.nix-ld

              nixos-hardware.nixosModules.lenovo-thinkpad-t14s
              # ./users/${username}/nixos.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.backupFileExtension = "backup";
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.${username} = import ./hosts/t14s/home.nix;
              }
            ];
          };

        wsl =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              # ./home/linux/gui.nix
              ./hosts/wsl

              nixos-wsl.nixosModules.wsl
              # ./users/${username}/nixos.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.${username} = import ./home/tui.nix;
              }
            ];
          };

        y50 =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/y50

              # ./users/${username}/nixos.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.${username} = import ./home/gui.nix;
              }
            ];
          };

        g8 =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/g8

              # ./users/${username}/nixos.nix
              lanzaboote.nixosModules.lanzaboote
              nix-ld.nixosModules.nix-ld

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./hosts/g8/home.nix;
                home-manager.users.${username} = {
                  imports = [
                    (import ./hosts/g8/home.nix)
                  ];
                };
                # home-manager.services.wayland.windowManager.hyprland = {
                #   monitor = "eDP-1,highres,auto,1.5,bitdepth,10";
                # };
              }
            ];
          };
        l6 =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/l6

              # ./users/${username}/nixos.nix
              # lanzaboote.nixosModules.lanzaboote
              nix-ld.nixosModules.nix-ld
              nixos-hardware.nixosModules.lenovo-thinkpad

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./hosts/g8/home.nix;
                home-manager.users.${username} = {
                  imports = [
                    dms.homeModules.dank-material-shell
                    (import ./hosts/l6/home.nix)
                  ];
                  home.username = username;
                  home.homeDirectory = "/home/${username}"; # add this
                };
                # home-manager.services.wayland.windowManager.hyprland = {
                #   monitor = "eDP-1,highres,auto,1.5,bitdepth,10";
                # };
              }
            ];
          };

        idpro =
          let
            username = "magnus";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/idpro
              ./modules/nixos/base/amd.nix
              # ./users/${username}/nixos.nix
              # lanzaboote.nixosModules.lanzaboote
              nix-ld.nixosModules.nix-ld
              # nixos-hardware.nixosModules.lenovo-ideapad
              nixos-hardware.nixosModules.lenovo-ideapad-16ahp9
              dms.nixosModules.dank-material-shell
              dms.nixosModules.greeter

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./hosts/g8/home.nix;
                home-manager.users.${username} = {
                  imports = [
                    # dms.homeModules.dank-material-shell
                    # dms.homeModules.niri
                    (import ./hosts/idpro/home.nix)
                  ];
                  home.username = username;
                  home.homeDirectory = "/home/${username}"; # add this
                };
                # home-manager.services.wayland.windowManager.hyprland = {
                #   monitor = "eDP-1,highres,auto,1.5,bitdepth,10";
                # };
              }
            ];
          };
        proxmox =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/proxmox

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.${username} = import ./home/tui.nix;
              }
            ];
          };
        atlas =
          let
            username = "ove";
            specialArgs = { inherit username; };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/atlas

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = inputs // specialArgs;
                # home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.${username} = import ./home/tui.nix;
              }
            ];
          };

      };
    };
}
