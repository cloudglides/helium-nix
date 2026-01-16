{
  description = "Community-driven Nix flake for the Helium browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = self.packages.${system}.helium;
        helium = pkgs.callPackage ./package.nix {};
      }
    );

    overlays.default = final: prev: {
      helium = final.callPackage ./package.nix {};
    };

    formatter = forAllSystems (
      system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
    );
  };
}
