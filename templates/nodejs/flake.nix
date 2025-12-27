{
  description = "Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core utilities
            wget
            yq
            jq

            # Node.js runtime
            nodejs_22
            nodePackages.npm

            # Development tools
            git
            curl
            tree

            # Language servers
            typescript-language-server
          ];

          shellHook = ''
            echo "Node.js Development Environment"
            echo "Node: $(node --version)"
            echo "npm: $(npm --version)"
            echo ""

            # Auto npm install if package.json exists and node_modules is missing/outdated
            if [ -f package.json ]; then
              if [ ! -d node_modules ] || [ package.json -nt node_modules ]; then
                echo "Installing dependencies..."
                npm install
              fi
            fi

            # Add node_modules/.bin to PATH
            export PATH="$PWD/node_modules/.bin:$PATH"

            echo ""
            echo "Available commands:"
            echo "  npm run dev      - Start development server"
            echo "  npm run build    - Build for production"
            echo "  npm run lint     - Run linter"
            echo ""
          '';
        };
      }
    );
}
