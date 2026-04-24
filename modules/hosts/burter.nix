{ den, ... }: {
  flake.den = den;  #
  den.hosts.x86_64-linux.burter.users.jcranney = { };

  # host aspect
  den.aspects.burter = {
    # host NixOS configuration
    nixos =
      { pkgs, ... }:
      {
        imports = [ 
            ./_nixos/configuration.nix 
            ./_nixos/hardware-configuration.nix 
        ];
      };
  };
}
