{
  description = "EDMarketConnector";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    formatter.x86_64-linux = pkgs.alejandra;
    packages.x86_64-linux = {
      edmarketconnector = pkgs.callPackage ./pkgs/edmarketconnector.nix {};
      min-ed-launcher = pkgs.callPackage ./pkgs/min-ed-launcher/min-ed-launcher.nix {};
      trakkr = pkgs.callPackage ./pkgs/trakkr/trakkr.nix {};
    };
  };
}
