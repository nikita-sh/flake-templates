{
  description = "rust flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    templates = {
      rust = {
        path = ./rust;
        description = "Basic rust project template.";
      };

      haskell = {
        path = ./haskell;
        description = "Haskell flake template";
      };
    };
  };
}
