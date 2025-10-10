# nix-configuration

so, not sure if this is the best solution but it's working for now.

On a new nixos machine, I need to clone this repo, then `rm -rf /etc/nixos` and replace it with a symlink to this repo. E.g., `ln -s $PARA_GIT/nix-configuration /etc/nixos`

This way I get updates through `para` if my config is out of sync.
