{
  # host aspect
  den.aspects.burter = {
    
    # Bootloader.
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.timeoutStyle = "hidden";
    
    networking.networkmanager.enable = true;

    # host NixOS configuration
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ 
          kdePackages.kcalc # Calculator
          kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
          kdePackages.kclock # Clock app
          kdePackages.kcolorchooser # A small utility to select a color
          kdePackages.ksystemlog # KDE SystemLog Application
          kdePackages.sddm-kcm # Configuration module for SDDM
          kdiff3 # Compares and merges 2 or 3 files or directories
          kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
          kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
          # Non-KDE graphical packages
          hardinfo2 # System information and benchmarks for Linux systems
          wayland-utils # Wayland utilities
          wl-clipboard # Command-line copy/paste utilities for Wayland
        ];
        imports = [ ./_nixos/burter-hardware-configuration.nix ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
      };
    
    services.openssh = {
      enable = true;
      openFirewall = true;
    };

    services.printing = { pkgs, ... }:
      {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
  
    virtualisation.docker.enable = true;

    programs.nix-ld = {
      enable = true;
    };
  
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };


    # Set your time zone.
    time.timeZone = "Australia/Sydney";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "au";
      variant = "";
    };
  };
}
