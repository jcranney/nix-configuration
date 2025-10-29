# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = let 
    # replace this with an actual commit id or tag
    sopsCommit = "6e5a38e08a2c31ae687504196a230ae00ea95133";
  in [ 
    <home-manager/nixos>
    ./hardware-configuration.nix
    "${builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/${sopsCommit}.tar.gz";
      # replace this with an actual hash
      sha256 = "02gmjxfad757d2c4is749sn2d781rw17y1fbw7xm6c4b9n5wmz2j";
    }}/modules/sops"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.timeoutStyle = "hidden";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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


  # to be able to talk to the 192.168.7.x subnet:
  networking.interfaces.wlp0s20f3 = {
    ipv4.addresses = [{
      address = "192.168.1.118";
      prefixLength = 16;
    }];
  };


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
  users.groups.libvirtd.members = ["your_username"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  nix.settings.trusted-users = [
    "root"
    "jcranney"
  ];


  # Use home manager to set up user configuration
  home-manager.users.jcranney = { pkgs, ... }: {
    nixpkgs.config.packageOverrides = pkgs: {
      nur-jcranney = import (fetchTarball "https://github.com/jcranney/nur-packages/archive/refs/tags/v0.4.tar.gz") {
        inherit pkgs;
      };
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    home.packages = with pkgs; [ 
      vim vscode ripgrep htop guake tldr wget dig  # core cli/dev tools
      insync nur-jcranney.para-audit  # filesystem/organisation
      openscad prusa-slicer freecad inkscape  # design/3d printing
      slack yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
      uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
      xournalpp libreoffice vlc  # normal human stuff
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
         vpn = "sudo gpclient --fix-openssl connect staff-access.anu.edu.au";
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

  programs.hyprland.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    kitty
    waybar
    wofi
    nwg-look
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
