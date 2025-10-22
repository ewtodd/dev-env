{
  description = "Nix Development Shell Flake Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            root
            (python3.withPackages (python-pkgs:
              with python-pkgs; [
                matplotlib
                numpy
                pandas
                tables
                mplhep
                uproot
                h5py
              ]))
          ];

          shellHook = ''
            echo "Development shell flake template!"
          '';
        };
      });
}
