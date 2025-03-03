{ pkgs ? import <nixpkgs> {} }:

let
  EliteDangerous.flake = pkgs.fetchFromGitHub {
    owner = "jiriks74";
    repo = "EliteDangerous.flake";
    rev = "main";
    hash = "sha256-5w1l2Gg4xEJJtmpvG6+Eashv/9POgxpxlKbdSuGSfls=";
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
