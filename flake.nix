{
  description = "A haskell based linker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      hpkgs = pkgs.haskell.packages.ghc944.override {
        overrides = hnew: hold: {
          linker = hnew.callCabal2nix "linker" ./. { };
        };
      };
    in
    {
      defaultPackage.x86_64-linux =  hpkgs.linker-project;
      inherit pkgs;
      devShell.x86_64-linux = hpkgs.shellFor {
        packages = ps : [ ps."linker" ];
        withHoogle = true;

        buildInputs = [
          pkgs.ghcid
          pkgs.cabal-install
        ];
      };
    };
}
