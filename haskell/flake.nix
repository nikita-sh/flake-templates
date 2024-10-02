{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem =
        {
          self',
          pkgs,
          system,
          ...
        }:
        {
          formatter = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
          haskellProjects.default = {
            basePackages = pkgs.haskellPackages;

            devShell = {
              enable = true;
              tools = hp: {
                inherit (hp) fourmolu;
                ghcid = null;
              };
              hlsCheck.enable = true;
            };
          };

          packages.default = self'.packages.template;
        };
    };
}
