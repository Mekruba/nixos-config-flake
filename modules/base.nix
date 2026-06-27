{
  config,
  pkgs,
  username,
  ...
}:
{

  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  nix.package = pkgs.nixVersions.latest;

  # for security reasons, do not load neovim's user config
  # since EDITOR may be used to edit some critical files
  environment.variables.EDITOR = "nvim --clean";

  environment.systemPackages = with pkgs; [
    # core tools
    fastfetch
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git # used by nix flakes
    git-lfs # used by huggingface models

    # archives
    zip
    xz

    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gawk # GNU awk, a pattern scanning and processing language
    jq # A lightweight and flexible command-line JSON processor

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    wget
    curl
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync
    pavucontrol
    tlrc
    playerctl
    mlocate
    # obs-studio

    # CPU power & clock monitoring
    linuxKernel.packages.linux_6_18.turbostat # Intel tool but works on AMD, shows per-core MHz/watts
    s-tui # TUI: real-time freq, temp, power, utilization graph

    # Stress Tools
    stress-ng

    # Hardware info & sensors
    lm_sensors # sensors command, hwmon
    hwinfo # deep hardware inventory
    dmidecode # BIOS/UEFI/board info

    # General system
    btop
    powertop # power consumption breakdown

    # Kernel / ACPI debugging
    acpica-tools # acpidump, acpiexec — dump raw ACPI tables
    pciutils # lspci
    usbutils # lsusb
  ];

  users.users.${username} = {
    description = username;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "ove";
    systemService = false;
  };

  nix.settings = {
    # enable flakes globally
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
