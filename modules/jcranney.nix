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
        vim ripgrep htop tldr wget # core cli/dev tools
        python3 python313Packages.astropy
        unzip tree gnumake watchexec
        prusa-slicer inkscape  # design/3d printing
        subversion gpclient  # aitc projects
        texliveFull mermaid-cli  # ultiamte subaru
        uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
        imagemagickBig  # normal human stuff
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
          snrs = "sudo nixos-rebuild switch";
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
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
      home.stateVersion = "25.11";
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
    };
  };
}
