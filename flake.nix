{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system}.extend (import ./nix/overlays.nix);
          in
          pkgs.ligoPackages
        );
      overlays.default = import ./nix/overlays.nix;
    };
}
