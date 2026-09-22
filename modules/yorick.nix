{ inputs, ... }: {
  den.aspects.yorick = {
    homeManager = { pkgs, ... }: {
      home.packages = with inputs.yorick-flake.packages.${pkgs.stdenv.hostPlatform.system}; [ 
        yorick spydr yao
      ];
    };
  };
}