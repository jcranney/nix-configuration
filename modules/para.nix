{
  den.aspects.jcranney = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        cowsay
        (rustPlatform.buildRustPackage rec {
          pname = "para-audit";
          version = "v0.1.17";
          cargoHash = "sha256-QNcyszJXlWRzmJv4Dz8Dj/BxnHay/WPvuSAxgI8AyR8=";
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [ openssl ];
          src = fetchgit {
            url = "https://github.com/jcranney/para-audit.git";
            tag = version;
            hash = "sha256-gdocardYVD5n/6Ry3Q5XvG6q6GiVi4twBwC99MQiNQc=";
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