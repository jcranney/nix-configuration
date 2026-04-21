# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.timeoutStyle = "hidden";

  networking.hostName = "burter"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # VM management
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jcranney"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  nix.settings.trusted-users = [
    "root"
    "jcranney"
  ];


  # Use home manager to set up user configuration
  home-manager.users.jcranney = { pkgs, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.git = {
      enable = true;
      settings = {
        user = {
          mail = "jesse.cranney@anu.edu.au";
          name = "Jesse Cranney";
        };
        core.editor = "vim";
      };
    };
    programs.fzf = {
      enable = true;
fileWidgetOptions = [
        "--preview 'head {}'"
      ];
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
         ll = "ls -ltAh";
         vpn = "sudo gpclient --fix-openssl connect staff-access.anu.edu.au";
         copy = "xclip -sel clip";
         ipython = "nix-shell -p python313 python313Packages.numpy python313Packages.ipython python313Packages.matplotlib --run ipython";
      };
      sessionVariables = {
         PARA_HOME = "$HOME/gdrive";
         PARA_GIT = "$HOME/git";
         EDITOR = "vim";
      };
      initContent = let
        paratracker = "$PARA_HOME/resources/para_tracking/para_tracker.py";
      in
        ''        
        ${paratracker}
        para audit
        '';
    };
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "mortalscumbag";
    };
    programs.firefox.enable = true;
    home.stateVersion = "25.11";
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    systemd.user.services.yakuake = {
      Unit = {
        Description = "yakuake drop down terminal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.kdePackages.yakuake}/bin/yakuake";
        Restart = "always";
      };
    };
  };
  users.users.jcranney = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # KDE
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
  nix.extraOptions = "experimental-features = nix-command";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  
  system.stateVersion = "25.05"; # never change this

}
