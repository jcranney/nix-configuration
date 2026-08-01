# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    para = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jcranney/para-audit";
    };
    shmim-tools = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jcranney/shmim-tools";
    };
    shmimshow = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jcranney/shmimshow";
    };
  };

}
