{ den, ... }:
{
  # user aspect
  den.aspects.jcranney = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.htop ];
      };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
