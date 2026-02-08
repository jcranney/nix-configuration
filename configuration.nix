# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.timeoutStyle = "hidden";

  networking.hostName = "nixos"; # Define your hostname.
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


  /*# to be able to talk to the 192.168.7.x subnet:
  networking.interfaces.wlp0s20f3 = {
    ipv4.addresses = [{
      address = "192.168.1.118";
      prefixLength = 16;
    }];
  };*/

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
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
        inherit pkgs;
      };
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    home.packages = with pkgs; [ 
      vim vscode ripgrep htop tldr wget dig xclip # core cli/dev tools
      unzip tree kdePackages.yakuake gnumake
      insync nur.repos.jcranney.para-audit  # filesystem/organisation
      openscad prusa-slicer inkscape  # design/3d printing
      slack yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
      texliveFull yed  # ultiamte subaru
      qbittorrent
      uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
      xournalpp libreoffice vlc imagemagickBig  # normal human stuff
    ];
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
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
         ll = "ls -ltAh";
         vpn = "sudo gpclient --fix-openssl connect staff-access.anu.edu.au";
         copy = "xclip -sel clip";
         ipy = "$HOME/.venv/bin/ipython";
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
   # systemd.user.services.vpn = {
   #   Unit = {
   #     Description = "GlobalProtect openconnect client";
   #   };
   #   Service = {
   #     ExecStart = "${pkgs.sudo}/bin/sudo ${pkgs.gpclient}/bin/gpclient --fix-openssl connect staff-access.anu.edu.au";
   #   };
   # };
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

  services.jellyfin = {
    enable = true;
    openFirewall = false;
    user = "jcranney";
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
    jellyfin jellyfin-web jellyfin-ffmpeg
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


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 1883 8886 ];
  # networking.firewall.allowedUDPPorts = [ 53 67 6666 6667 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
