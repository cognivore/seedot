{
  description = "A Nix flake for seedot";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname    = "seedot";
          version  = "1.0.0";
          src      = ./.;

          buildInputs = [];

          installPhase = ''
            mkdir -p $out/bin
            cp seedot $out/bin/
            chmod +x $out/bin/seedot
          '';

          meta = with pkgs.lib; {
            description  = "seedot prints a bunch of file contents with their file names";
            homepage     = "https://github.com/cognivore/seedot";
            license      = licenses.mit;
            maintainers  = with maintainers; [ ];
            platforms    = platforms.unix;
          };
        };
      });
}

