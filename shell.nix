{ pkgs ? import <nixpkgs> {} }:

let
  EliteDangerous.flake = pkgs.fetchFromGitHub {
    owner = "jiriks74";
    repo = "EliteDangerous.flake";
    rev = "ac1f7d68cf33004b50dd3e9f0837a485b6795255";
    hash = "sha256-J2S9co53pYfSIQvXHxc/+7F5DO5qygxIgYnFuaqRMCs=";
  };
  min-ed-launcher = (pkgs.callPackage "${EliteDangerous.flake}/pkgs/min-ed-launcher/min-ed-launcher.nix" {});
  EDMarketConnector = (pkgs.callPackage "${EliteDangerous.flake}/pkgs/EDMarketConnector.nix" {});
  Trakkr = (pkgs.callPackage "${EliteDangerous.flake}/pkgs/Trakkr.nix" {});
in
pkgs.mkShell {
  name = "Trakkr dev env";
  packages = [
    min-ed-launcher
    EDMarketConnector
    Trakkr
  ];
}
