{
  description = "Development environment templates with common tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
            echo "Available templates: default, blender, zola, zola-blog-init"
            echo "Usage: nix flake init -t github:gui-baeta/flakes"
          '';
        };
      }
    )
    // {
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

        zola = {
          path = ./templates/zola;
          description = "Zola static site generator development environment";
          welcomeText = ''
            # Zola Static Site Template

            This template provides a development environment for Zola static sites with:
            - Zola static site generator
            - Node.js for additional tooling
            - Python 3 for scripting
            - Common utilities: wget, yq, jq
            - Git and basic development tools
            - MCP server configuration for AI assistance

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Create and serve site
            ```bash
            zola init mysite && cd mysite
            nix run          # Start development server
            nix run .#build  # Build static site
            ```
          '';
        };

        zola-blog-init = {
          path = ./templates/zola-blog-init;
          description = "Zola blog theme creation template with Cloudflare Pages deployment setup";
          welcomeText = ''
            # Zola Blog Theme Initialization Template

            This template provides everything needed to create a complete minimal Zola blog theme
            optimized for Cloudflare Pages deployment with:
            - Zola static site generator
            - Specialized blog theme creation prompt in CLAUDE.md
            - Complete theme setup guide with templates, styles, and deployment
            - Node.js for additional tooling
            - Python 3 for scripting
            - Common utilities: wget, yq, jq
            - MCP server configuration for AI assistance

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Using with Claude Code

            This template includes a specialized CLAUDE.md with a comprehensive prompt for
            building production-ready blog themes. Use it with Claude Code like this:

            ```bash
            zola init my-blog && cd my-blog
            # The CLAUDE.md contains detailed instructions for theme creation
            
            # Example prompt to get started:
            # "I want to build a minimal Zola blog theme following the CLAUDE.md prompt.
            #  Please read the CLAUDE.md file and create the complete theme structure 
            #  with config.toml, templates/, sass/, and content/ directories.
            #  Focus on card-based post layouts and Cloudflare Pages deployment."
            ```

            ## Development commands
            ```bash
            nix run          # Start development server (zola serve)
            nix run .#build  # Build static site (zola build)
            ```

            The CLAUDE.md file contains a complete implementation guide with:
            - Step-by-step theme creation instructions
            - Template code for all required files
            - Sass styling with responsive design
            - Cloudflare Pages deployment configuration
            - Content structure and example posts

            Perfect for creating professional blog themes with AI assistance!
          '';
        };
      };
    };
}
