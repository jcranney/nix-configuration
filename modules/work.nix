{den,...}: {
  den.aspects.work = {
    includes = [ den.aspects.magicdraw ];
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        python3 python313Packages.astropy
        subversion gpclient  # aitc projects
        imagemagickBig  # normal human stuff
      ];
    };
  };
}
