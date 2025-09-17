{
  description = "Development environment templates with common tools";

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
        # Default development shell with common tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            wget
            yq
            jq
            nodejs
            python3
          ];
          shellHook = ''
            echo "🧊 Nix Development Environment"
            echo "Available templates: frontend, backend, scripting"
            echo "Usage: nix flake init -t github:your-username/flakes#template-name"
          '';
        };
      }
    ) // {
      # Template definitions
      templates = {
        default = {
          path = ./templates/default;
          description = "General-purpose development environment with Node.js, Python, and common utilities";
          welcomeText = ''
            # Development Template

            This template provides a general-purpose development environment with:
            - Node.js and npm
            - Python 3 with pip
            - Common utilities: wget, yq, jq
            - Git and basic development tools
            - MCP server configuration for AI assistance
            - Example package and app setup

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Try the example app
            ```bash
            nix run
            ```
          '';
        };

        blender = {
          path = ./templates/blender;
          description = "Blender development environment with Blender, uv, and common utilities";
          welcomeText = ''
            # Blender Development Template

            This template provides a development environment for Blender projects with:
            - Blender for 3D modeling and animation
            - uv for Python package management
            - Python 3 for scripting
            - Common utilities: wget, yq, jq
            - Git and basic development tools
            - Blender MCP server configuration

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Launch Blender
            ```bash
            blender
            ```
          '';
        };
      };
    };
}