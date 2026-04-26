{ den, ... }: {
  flake.den = den;  #
  den.hosts.x86_64-linux.burter.users.jcranney = {
    includes = [
      den.aspects.graphical
      den.provides.primary-user
    ];
  };

  den.aspects.burter = {
    den.provides.primary-user = [ "jcranney" ];
    # host NixOS configuration
    nixos = { pkgs, ... }:
    {
      imports = [ 
        ./_nixos/configuration.nix 
        ./_nixos/hardware-configuration.nix 
      ];
    };
    # burter-jesse specific configuration
    provides.jcranney = {
      homeManager = { pkgs, ... }: {
        home.packages = with pkgs; [
          slack 
        ];
      };
    };
  };
}
