{
  description = "Rust project flake template.";
	
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk/master";
    rust-overlay.url = "github:oxalica/rust-overlay";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk, rust-overlay }:
    utils.lib.eachDefaultSystem (system:
      let
        naersk-lib = pkgs.callPackage naersk { };
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in 
      {
        defaultPackage = naersk-lib.buildPackage ./.;
        devShell = with pkgs; mkShell {
          buildInputs = [ rustToolchain openssl.dev pkg-config ];
          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      }
    );
}
