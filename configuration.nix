 { config, pkgs, ... }:
 
 {
   imports = [ 
     <home-manager/nixos>
     ./hardware-configuration.nix
   ];
 
   # Bootloader.
   boot.loader.grub.enable = true;
   boot.loader.grub.device = "/dev/sda";
   boot.loader.grub.useOSProber = true;
 
   networking.hostName = "nixos"; # Define your hostname.
   # Enable networking
   networking.networkmanager.enable = true;
 
   # Set your time zone.
   time.timeZone = "Australia/Sydney";
 
   # Select internationalisation properties.
   i18n.defaultLocale = "en_AU.UTF-8";
 
   i18n.extraLocaleSettings = {
     LC_ADDRESS = "en_AU.UTF-8";
     LC_TIME = "en_AU.UTF-8";
   };
 
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
      vim ripgrep htop tldr wget dig xclip # core cli/dev tools
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
    home.stateVersion = "25.05";
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
  };
   # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.jcranney = {
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" "docker" ];
     shell = pkgs.zsh;
   };
 
   environment.pathsToLink = [ "/share/zsh" ];
   programs.zsh.enable = true;
   # Enable automatic login for the user.
   services.getty.autologinUser = "jcranney";
 
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
 
   services.openssh.enable = true;
   networking.firewall.enable = false;
   system.stateVersion = "25.05";
 }
