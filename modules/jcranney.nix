{ den, ... }:
{
  # user aspect
  den.aspects.jcranney = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [       
          vim vscode ripgrep htop tldr wget dig xclip # core cli/dev tools
          arduino-ide
          unzip tree kdePackages.yakuake gnumake watchexec
          insync
          openscad freecad
          prusa-slicer inkscape  # design/3d printing
          slack yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
          texliveFull yed mermaid-cli  # ultiamte subaru
          qbittorrent
          uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
          xournalpp libreoffice vlc imagemagickBig  # normal human stuff
        ];
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

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  
    # List packages installed in system profile. To search, run:
    environment = { pkgs, ...}: {
      systemPackages = 
      with pkgs; [
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
  };
}
