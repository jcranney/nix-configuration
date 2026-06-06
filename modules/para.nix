{
  den.aspects.jcranney = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        cowsay
        (rustPlatform.buildRustPackage rec {
          pname = "para-audit";
          version = "v0.1.18";
          cargoHash = "sha256-yEQqZpwDboYICw9+6UZaqY8sypid5khDJHA4Vk9nAB0=";
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [ openssl ];
          src = fetchgit {
            url = "https://github.com/jcranney/para-audit.git";
            tag = version;
            hash = "sha256-DOy5qpd8M1OvU8MHkC4xD5WYSV/Mes36iQl0r/46IrE=";
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