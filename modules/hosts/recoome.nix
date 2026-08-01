{ den, ... }: {
  flake.den = den;
  den.hosts.x86_64-linux.recoome.users.jcranney = {};

  den.aspects.recoome = {
    includes = [
      den.aspects.systemd-boot
      den.aspects.graphical
    ];
    nixos = {
      imports = [ 
        ./_nixos/recoome-hardware-configuration.nix 
      ];
      programs.steam.enable = true;
    };
    provides.jcranney = {
      includes = [
        den.aspects.graphical
        den.aspects.para
        # den.aspects.shmim
        den.batteries.primary-user
        den.aspects.work
      ];
      homeManager = { pkgs, ... }: {
        home.packages = with pkgs; [
          slack 
        ];
      };
    };
  };
}
