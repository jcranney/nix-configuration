{ den, pkgs, ... }: {
  flake.den = den;  #
  den.hosts.x86_64-linux.burter.users.jcranney = {};
  #   includes = [
  #     den.provides.primary-user
  #   ];
  # };

  den.aspects.burter = {
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
