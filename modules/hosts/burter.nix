{ den, ... }: {
  flake.den = den;  #
  den.hosts.x86_64-linux.burter.users.jcranney = {};

  den.aspects.burter = {
    # host NixOS configuration
    includes = [
      den.aspects.systemd-boot
      den.aspects.graphical
    ];
    nixos = {
      imports = [ 
        ./_nixos/burter-hardware-configuration.nix 
      ];
    };

    # burter-jesse specific configuration
    provides.jcranney = {
      includes = [
        den.aspects.graphical
        den.batteries.primary-user
      ];
      homeManager = { pkgs, ... }: {
        home.packages = with pkgs; [
          slack
        ];
      };
    };
  };
}
