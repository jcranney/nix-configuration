{
  den.aspects.graphical = {
    nixos = { pkgs, lib, ... }: {
      programs.niri.enable = true;
      programs.dms-shell.enable = true;
      # services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

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
        xwayland-satellite
      ];
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
      ];
      services.upower.enable = true;
      environment.variables = {
        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
          vulkan-loader
        ];
      };
    };
    homeManager = { pkgs, config, lib, ... }: {
      home.packages = with pkgs; [
        qbittorrent vscode arduino-ide kdePackages.yakuake
        freecad insync
        prusa-slicer inkscape  # design/3d printing
        insync kicad ltspice wine
        arduino-ide bitwarden-desktop
        slack yed zoom-us graphviz
        texliveFull mermaid-cli  # ultiamte subaru
        xournalpp libreoffice vlc
        # openscad # on their own lines because they keep breaking
        swaybg # wallpaper
        nautilus
      ];
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
      programs.zsh = {
        initContent = let
          paratracker = "$PARA_HOME/resources/para_tracking/para_tracker.py";
        in
          ''        
          ${pkgs.uv}/bin/uv run ${paratracker}
          para audit
          '';
      };
      # for niri:
      programs.alacritty.enable = true; # Super+T in the default setting (terminal)
      programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
      services.mako.enable = true; # notification daemon
      services.swayidle.enable = true; # idle management daemon
      services.polkit-gnome.enable = true; # polkit
    };
  };
}
