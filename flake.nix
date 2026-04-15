{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      eachSystem = fn: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed fn;
    in
    {
      packages = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./package.nix { };
      });
    };
}
