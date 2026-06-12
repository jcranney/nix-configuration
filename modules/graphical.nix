{
  den.aspects.graphical = {
    nixos = { pkgs, ... }: {
      services.desktopManager.plasma6.enable = true;
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
      ];
    };
    homeManager = { pkgs, config, ... }: {
      home.packages = with pkgs; [
        qbittorrent vscode arduino-ide kdePackages.yakuake
        freecad insync
        prusa-slicer inkscape  # design/3d printing
        insync kicad ltspice wine
        arduino-ide kdePackages.yakuake 
        slack yed zoom-us graphviz
        texliveFull mermaid-cli  # ultiamte subaru
        xournalpp libreoffice vlc
        # openscad # on their own lines because they keep breaking
      ];
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
      programs.zsh = {
        shellAliases = {
          vpn = "sudo gpclient --fix-openssl connect staff-access.anu.edu.au";
        };
        initContent = let
          paratracker = "$PARA_HOME/resources/para_tracking/para_tracker.py";
        in
          ''        
          ${pkgs.uv}/bin/uv run ${paratracker}
          para audit
          '';
      };
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
  };
}
