{
  description = "Nix Development Shell Flake Template";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            gnumake
            clang-tools
          ];
          buildInputs = with pkgs; [
            root
            bash
            gnumake
            (python3.withPackages (
              python-pkgs: with python-pkgs; [
                matplotlib
                numpy
                pandas
              ]
            ))
          ];
          shellHook = ''
            export SHELL="${pkgs.bash}/bin/bash"
            echo "ROOT version: $(root-config --version)"
            STDLIB_PATH="${pkgs.stdenv.cc.cc}/include/c++/${pkgs.stdenv.cc.cc.version}"
            STDLIB_MACHINE_PATH="$STDLIB_PATH/x86_64-unknown-linux-gnu"
            ROOT_INC="$(root-config --incdir)"
            # Local first, then remote, then others
            export CPLUS_INCLUDE_PATH="$PWD/include:$STDLIB_PATH:$STDLIB_MACHINE_PATH:$ROOT_INC''${CPLUS_INCLUDE_PATH:+:$CPLUS_INCLUDE_PATH}"
            export ROOT_INCLUDE_PATH="$PWD/include''${ROOT_INCLUDE_PATH:+:$ROOT_INCLUDE_PATH}"
            # Local lib first means linker will use it preferentially
            export LD_LIBRARY_PATH="$PWD/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          '';
        };
      }
    );
}
