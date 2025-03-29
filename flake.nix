{
  description = "A Nix flake for seedot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # Ensure nixpkgs is included as an input
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; }; # Corrected import statement
    in
    {
      # Define the package
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "seedot";
        version = "1.0.0";

        # Use the current directory as the source
        src = ./.;

        # No dependencies are needed
        buildInputs = [];

        # Install phase to copy files and create the wrapper script
        installPhase = ''
          mkdir -p $out/bin

          # Install the seedot script
          cp seedot $out/bin/
          chmod +x $out/bin/seedot
        '';

        # Metadata for the package
        meta = with pkgs.lib; {
          description = "seedot is way to print a bunch of file contents with their file names";
          homepage = "https://github.com/cognivore/seedot";
          license = licenses.mit;
          maintainers = with maintainers; [ ]; # Add your name or GitHub handle here
          platforms = platforms.unix;
        };
      };
    };
}
