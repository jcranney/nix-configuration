{ den, ... }: {
  den.aspects.jcranney = {
    includes = [
        (den.batteries.user-shell "zsh")
    ];
    user.extraGroups = [ "docker" "dialout" ];
    nixos = {
      programs.nix-ld = {
        enable = true;
      };
      programs.ssh = {
        forwardX11 = true;
        setXAuthLocation = true;
      };
      programs.zsh.enable = true;
      virtualisation.docker.enable = true;
      services.tailscale = {
        enable = false;
        # Enable tailscale at startup

        # If you would like to use a preauthorized key
        #authKeyFile = "/run/secrets/tailscale_key";
  };
    };
    homeManager = { pkgs, config, nixos, ... }: {
      home.packages = with pkgs; [ 
        nixd cargo-flamegraph
        vim ripgrep htop tldr wget # core cli/dev tools
        unzip tree gnumake watchexec
        uv openssl waypipe
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
        fileWidget.options = [
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
      home.stateVersion = "25.11";
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
    };
  };
}
