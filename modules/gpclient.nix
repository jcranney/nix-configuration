{
  den.aspects.gpclient = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ gpclient ];
      programs.zsh = {
        shellAliases = {
          vpn = "sudo gpclient --fix-openssl connect gpgw1.anu.edu.au --browser default";
        };
      };
    };
  };
}