{
  description = "Zola static site generator development environment";

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
        # Apps for different Zola commands
        apps = {
          default = {
            type = "app";
            program = "${pkgs.writeShellScript "zola-serve" ''
              echo "🌐 Starting Zola development server..."
              ${pkgs.zola}/bin/zola serve --open
            ''}";
          };
          
          build = {
            type = "app";
            program = "${pkgs.writeShellScript "zola-build" ''
              echo "🏗️  Building Zola site..."
              ${pkgs.zola}/bin/zola build
              echo "✅ Site built successfully in ./public/"
            ''}";
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core utilities (always included)
            wget
            yq
            jq
            
            # Runtime environments
            nodejs
            python3
            
            # Zola static site generator
            zola
            
            # Development tools
            git
            curl
            tree
            
            # Code editors and tools
            nano
            vim
          ];
          
          shellHook = ''
            echo "📝 Zola Static Site Development Environment"
            echo "Zola: $(zola --version)"
            echo "Node.js: $(node --version)"
            echo "Python: $(python --version)"
            echo ""
            echo "Available commands:"
            echo "  - zola init mysite   # Create a new Zola site"
            echo "  - zola serve         # Start development server"
            echo "  - zola build         # Build static site"
            echo "  - nix run            # Start dev server (same as zola serve)"
            echo "  - nix run .#build    # Build site"
          '';
        };
      }
    );
}