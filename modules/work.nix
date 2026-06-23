{den,...}: {
  den.aspects.work = {
    includes = [ den.aspects.gpclient ];
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        python3 python313Packages.astropy
        subversion  # aitc projects
        imagemagickBig  # normal human stuff
      ];
    };
  };
}
