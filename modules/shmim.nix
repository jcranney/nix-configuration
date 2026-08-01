{ inputs, ... }: {
  den.aspects.shmim = {
    homeManager = { pkgs, ... }: {
      home.packages = [ 
        inputs.shmim-tools.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.shmimshow.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}