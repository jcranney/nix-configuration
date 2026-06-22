{ inputs, ... }: {
  den.aspects.para = {
    homeManager = { pkgs, ... }: {
      home.packages = [ inputs.para.packages.${pkgs.system}.default ];
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