{
  den.aspects.jcranney = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        cowsay
        (rustPlatform.buildRustPackage rec {
          pname = "para-audit";
          version = "v0.1.16";
          cargoHash = "sha256-WI7xjYGaPgvnhNmzZc77v+rAxjxSwXpIhvzNFIVZqSY=";
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [ openssl ];
          src = fetchgit {
            url = "https://github.com/jcranney/para-audit.git";
            tag = version;
            hash = "sha256-/27GRBca2F2LnD8Pwh8EcoE0heeRMsVZ8cU13uzgnec=";
          };
          meta = with lib; {
            description = "A tool for auditing/organising/interacting with my para system.";
            homepage = "https://github.com/jcranney/para-audit";
            license = licenses.unlicense;
            platforms = platforms.all;
            mainProgram = "para";
          };
        })
      ];
      programs.zsh = {
        sessionVariables = {
          PARA_HOME = "$HOME/gdrive";
          PARA_GIT = "$HOME/git";
          PARA_CONFIG = "$HOME/.config/para-audit/config.yaml";
        };
      };
    };
  };
}