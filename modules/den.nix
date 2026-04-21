{ inputs, den, lib, ... }: {
  imports = [ inputs.den.flakeModule ]; # (1)

  # den.schema.user.classes = lib.mkDefault [ "homeManager" ]; # (2)

  den.default.homeManager.home.stateVersion = "25.11"; # (3)

  den.hosts.x86_64-linux.burter.users.jcranney = {}; # (4) (5)

  den.aspects.burter = { # (6)
    includes = [ den.provides.hostname ]; # (7)
    nixos = { pkgs, ... }: {
      imports = [ ./_nixos/configuration.nix ]; # (8)
      environment.systemPackages = [ pkgs.hello ];
    };
  };

  den.aspects.jcranney = { # (9)
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
    includes = [ den.provides.define-user den.provides.primary-user ]; # (10)
    homeManager = { pkgs, ... }: {
      nixpkgs.config.packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
          inherit pkgs;
        };
      };
      home.packages =  with pkgs; [
      vim vscode ripgrep htop tldr wget dig xclip # core cli/dev tools
      arduino-ide ffmpeg_7-full
      unzip tree kdePackages.yakuake gnumake watchexec
      insync nur.repos.jcranney.para-audit  # filesystem/organisation
      openscad freecad
      prusa-slicer inkscape  # design/3d printing
      slack yed zoom-us quickemu graphviz subversion gpclient  # aitc projects
      texliveFull yed mermaid-cli  # ultiamte subaru
      qbittorrent
      uv cargo rustc maturin clang openssl pkg-config  # python + rust (until I master flakes)
      xournalpp libreoffice vlc imagemagickBig  # normal human stuff
      ];
    };
  };
}
