{
  den.aspects.jcranney = {
    user.extraGroups = [ "docker" "dialout" ];
    nixos = {
      programs.nix-ld = {
        enable = true;
      };
      programs.zsh.enable = true;
      virtualisation.docker.enable = true;
    };
    homeManager = { pkgs, config, nixos, ... }: {
      home.packages = with pkgs; [ 
        hello nixd cargo-flamegraph
        vim vscode ripgrep htop tldr wget dig xclip # core cli/dev tools
        arduino-ide python3
        python313Packages.astropy
        unzip tree kdePackages.yakuake gnumake watchexec
        insync # nur.repos.jcranney.para-audit  # filesystem/organisation
        prusa-slicer inkscape  # design/3d printing
        slack yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
        texliveFull yed mermaid-cli  # ultiamte subaru
        uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
        xournalpp libreoffice vlc imagemagickBig  # normal human stuff
      ];
  
      programs.direnv.enable = true;

      programs.git = {
        enable = true;
        settings = {
          pull.rebase = true;
          user = {
            email = "jesse.cranney@anu.edu.au";
            name = "Jesse Cranney";
          };
          github.user = "jcranney";
          core.editor = "vim";
          init.defaultBranch = "main";
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
          snrs = "sudo nixos-rebuild switch";
        };
        sessionVariables = {
          EDITOR = "vim";
        };
        initContent = let
          paratracker = "$PARA_HOME/resources/para_tracking/para_tracker.py";
        in
          ''        
          ${pkgs.uv}/bin/uv run ${paratracker}
          para audit
          '';
      };
      programs.zsh.oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "mortalscumbag";
      };
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
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
  };
}
