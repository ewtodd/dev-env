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
          nativeBuildInputs = with pkgs; [ pkg-config ];
          buildInputs = with pkgs; [
            root
            gnumake
            (python3.withPackages
              (python-pkgs: with python-pkgs; [ matplotlib numpy pandas ]))
          ];
          shellHook = ''
            STDLIB_PATH="${pkgs.stdenv.cc.cc}/include/c++/${pkgs.stdenv.cc.cc.version}"
            STDLIB_MACHINE_PATH="$STDLIB_PATH/x86_64-unknown-linux-gnu"
            export CPLUS_INCLUDE_PATH="$STDLIB_PATH:$STDLIB_MACHINE_PATH:$PWD/include:$(root-config --incdir):$CPLUS_INCLUDE_PATH"
            export ROOT_INCLUDE_PATH="$PWD/include:$(root-config --incdir)"
            export LD_LIBRARY_PATH="$PWD/lib:$LD_LIBRARY_PATH"

            echo "C++ stdlib: $STDLIB_PATH"
          '';
        };
      });
}
