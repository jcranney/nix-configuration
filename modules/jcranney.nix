{ ... }:
{
  den.aspects.jcranney = {
    homeManager = { pkgs, ... }: 
    # let 
    #   nur = import (builtins.fetchTarball {
    #     url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
    #     sha256 = "sha256:1p9jz85zij4crfj010zdl3p22qxhriv48l5p573jcdx6g10q8hnf";
    #   }) { inherit pkgs; };
    # in
    {
      home.packages = with pkgs; [ 
        vim ripgrep htop tldr wget dig xclip # core cli/dev tools
        ffmpeg_7-full
        vscode insync 
        unzip tree gnumake watchexec
        # nur.repos.jcranney.para-audit # filesystem/organisation
        yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
        texliveFull yed mermaid-cli  # ultiamte subaru
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
  };
}