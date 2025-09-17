{
  description = "Blender development environment";

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
            # Core utilities (always included)
            wget
            yq
            jq
            
            # Runtime environments
            nodejs
            python3
            
            # Blender and dependencies
            blender
            uv
            
            # Development tools
            git
            curl
            tree
            
            # Code editors and tools
            nano
            vim
          ];
          
          shellHook = ''
            echo "🎨 Blender Development Environment"
            echo "Blender: $(blender --version | head -n1)"
            echo "Python: $(python --version)"
            echo "uv: $(uv --version)"
            echo ""
            echo "Available tools:"
            echo "  - Blender for 3D modeling and animation"
            echo "  - uv for Python package management"
            echo "  - Core utilities: wget, yq, jq"
            echo ""
            echo "Get started with Blender development!"
          '';
        };
      }
    );
}