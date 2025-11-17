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

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    file-roller # archive manager
    geary       # email client
    seahorse    # password manager
    gnome-contacts gnome-maps gnome-music gnome-weather
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  nix.settings.trusted-users = [
    "root"
    "jcranney"
  ];

  # Use home manager to set up user configuration
  home-manager.users.jcranney = { pkgs, ... }: {
    nixpkgs.config.packageOverrides = pkgs: {
      nur-jcranney = import (fetchTarball "https://github.com/jcranney/nur-packages/archive/refs/tags/v0.5.tar.gz") {
        inherit pkgs;
      };
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    home.packages = with pkgs; [ 
      vim vscode ripgrep htop guake tldr wget dig xclip # core cli/dev tools
    ];
    programs.git = {
      enable = true;
      extraConfig.core.editor = "vim";
      userEmail = "jesse.cranney@anu.edu.au";
      userName = "Jesse Cranney";
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
         ll = "ls -ltAh";
         copy = "xclip -sel clip";
      };
      sessionVariables = {
         EDITOR = "vim";
      };
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
    programs.rbw = {
      enable = true;
      settings = {
        email = "jac1616@hotmail.com";
        lock_timeout = 300;
        pinentry = pkgs.pinentry-gnome3;
        base_url = "https://vault.donfax.com";
      };
    };
    systemd.user.services.guake = {
      Unit = {
        Description = "Guake drop down terminal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.guake}/bin/guake --hide";
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

  environment.systemPackages = with pkgs; [
  ];
  nix.extraOptions = "experimental-features = nix-command";


  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 1883 8886 ];
  # networking.firewall.allowedUDPPorts = [ 53 67 6666 6667 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
