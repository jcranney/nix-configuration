{ den, ... }: {
  flake.den = den;
  den.hosts.x86_64-linux.recoome.users.jcranney = {};

  den.aspects.recoome = {
    includes = [
      den.aspects.systemd-boot
      den.aspects.graphical
      den.aspects.work
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
        den.batteries.primary-user
        den.aspects.para
      ];
      homeManager = { pkgs, ... }: {
        home.packages = with pkgs; [
          slack 
        ];
      };
    };
  };
}
