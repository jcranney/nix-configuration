{
  den.aspects.gpclient = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ gpclient ];
      programs.zsh = {
        shellAliases = {
          vpn = "sudo gpclient --fix-openssl connect staff-access.anu.edu.au";
        };
      };
    };
  };
}