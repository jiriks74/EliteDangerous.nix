# EliteDangerous.flake

Elite: Dangerous tools packaged for nix.

> [!Important]
> This repository will change. Packages will get deprecated once upstream.

## Packages

There are currently only 2 tools provided:
- [min-ed-launcher](https://github.com/rfvgyhn/min-ed-launcher)
- [EDMarketConnector](https://github.com/EDCD/EDMarketConnector)

## Installation

*This installation guide was inspired by
[legendario/dzgui-nix](https://github.com/lelgenio/dzgui-nix)'s README
under the MIT license.*

### On non flake NixOs systems

```nix
# configuration.nix
{ pkgs, ... }:
let
  EliteDangerous.flake = pkgs.fetchFromGitHub {
    owner = "jiriks74";
    repo = "EliteDangerous.flake";
    rev = "32d6e81e47f367bd0469fe0388c9ff45dad7252a";
    hash = "sha256-4cPoqYvBoNU0fr5FhzryqG5bSnoSmUkVQgBzpAaLZCk=";
  };
  min-ed-launcher = (pkgs.callPackage "${EliteDangerous.flake}/pkgs/min-ed-launcher/min-ed-launcher.nix" {});
  EDMarketConnector = (pkgs.callPackage "${EliteDangerous.flake}/pkgs/EDMarketConnector.nix" {});
in
{
  environment.systemPackages = [
    min-ed-launcher
    EDMarketConnector
  ];
}
```

### As part of a NixOs system flake

Flake users are assumed to have a `flake.nix` file and a `configuration.nix`.

1 - Add `EliteDangerous.flake` as a flake input:

```nix
# flake.nix
{
    inputs.EliteDangerous = {
        # url of this repository, may change in the future
        url = "github:jiriks74/EliteDangerous.flake";
        # save storage by not having duplicates of packages
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # other inputs...
}
```

2 - Add the `dzgui` package to your environment packages:

```nix
# flake.nix
{
    outputs = inputs@{pkgs, ...}: {
        nixosConfigurations.your-hostname-here = lib.nixosSystem {
            modules = [
                {
                  environment.systemPackages = [
                    inputs.EliteDangerous.flake.packages.min-ed-launcher
                    inputs.EliteDangerous.flake.packages.EDMarketConnector
                  ];
                }
                # other modules...
            ];
        };
    };
}
```

3 - Rebuild your system

```sh
nixos-rebuild --switch --flake .#your-hostname-here
```

Now dzgui will update together with your flake:

```sh
nix flake update
```

## Contributing

Feel free to add/update any package. Keep in mind that any contributions
may be merged into `nixpkgs` under my maintainership. Feel free to add yourself
as a maintainer as well if you're interested.
