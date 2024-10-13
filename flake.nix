{
  description = "A Nix flake for shmux with custom tmux configuration";

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
        pname = "shmux";
        version = "1.0.0";

        # Use the current directory as the source
        src = ./.;

        # No dependencies are needed
        buildInputs = [];

        # Install phase to copy files and create the wrapper script
        installPhase = ''
          mkdir -p $out/bin

          # Install the shmux script
          cp shmux $out/bin/
          chmod +x $out/bin/shmux

          # Install the _tmux.conf file
          cp _tmux.conf $out/

          # Create the shx wrapper script
          cat > $out/bin/shx << EOF
          #!/usr/bin/env bash
          export SHMUX_TMUX_CONF="$out/_tmux.conf"
          exec "$out/bin/shmux" "\$@"
          EOF

          chmod +x $out/bin/shx
        '';

        # Metadata for the package
        meta = with pkgs.lib; {
          description = "shmux script with custom tmux configuration and shx wrapper";
          homepage = "https://example.com/shmux"; # Replace with actual homepage if available
          license = licenses.mit;
          maintainers = with maintainers; [ ]; # Add your name or GitHub handle here
          platforms = platforms.unix;
        };
      };
    };
}
