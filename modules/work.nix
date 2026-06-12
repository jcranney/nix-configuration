{
  den.aspects.work = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ 
        python3 python313Packages.astropy
        subversion gpclient  # aitc projects
        imagemagickBig  # normal human stuff
      ];
    };
  };
}
