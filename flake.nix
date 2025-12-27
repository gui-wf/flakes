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
            echo "Nix Development Environment"
            echo "Available templates: default, blender, mcp-server, zola, zola-blog-init, nodejs, python"
            echo "Usage: nix flake init -t github:gui-baeta/flakes#<template>"
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

        mcp-server = {
          path = ./templates/mcp-server;
          description = "TypeScript-based Model Context Protocol (MCP) server development environment";
          welcomeText = ''
            # MCP Server Development Template

            This template provides a complete development environment for building MCP servers with:
            - Node.js 20 with npm for JavaScript/TypeScript runtime
            - TypeScript compiler and language server for type-safe development
            - Secrets management with sops and age for secure API key handling
            - Core utilities: wget, yq, jq, curl, tree
            - Git and development tools
            - Production build configuration with buildNpmPackage
            - Comprehensive CLAUDE.md with MCP best practices

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Quick start workflow
            ```bash
            npm init -y                              # Initialize project
            npm install @modelcontextprotocol/sdk   # Install MCP SDK
            npm install -D typescript @types/node   # Install dev dependencies
            npm run dev                             # Run in development mode
            npm run inspector                       # Test with MCP Inspector
            ```

            ## Secrets management
            The template includes sops/age for managing API keys and secrets:
            - Store encrypted secrets in .mcp.env.enc
            - Auto-decrypt on shell entry
            - Never commit plaintext secrets

            ## Production build
            Update the flake.nix production package configuration and run:
            ```bash
            nix build    # Build production package
            nix run      # Run the built server
            ```

            See CLAUDE.md for comprehensive MCP server development guidelines, patterns, and best practices.
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

        nodejs = {
          path = ./templates/nodejs;
          description = "Node.js development environment with npm and TypeScript support";
          welcomeText = ''
            # Node.js Development Template

            This template provides a Node.js development environment with:
            - Node.js 22 with npm
            - TypeScript Language Server for IDE support
            - Auto npm install when package.json changes
            - Common utilities: wget, yq, jq, git, curl
            - MCP server configuration for AI assistance

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Quick start
            ```bash
            npm init -y                    # Initialize project
            npm install                    # Install dependencies
            npm run dev                    # Start development server
            ```

            ## Create a Vite project
            ```bash
            npm create vite@latest my-app -- --template react-ts
            cd my-app && npm install
            npm run dev
            ```

            See CLAUDE.md for development guidelines and patterns.
          '';
        };

        python = {
          path = ./templates/python;
          description = "Python development environment with uv package manager and venv support";
          welcomeText = ''
            # Python Development Template

            This template provides a Python development environment with:
            - Python 3 with virtual environment support
            - uv for fast, modern package management
            - Python LSP Server for IDE support
            - Auto venv creation on shell entry
            - Common utilities: wget, yq, jq, git, curl
            - MCP server configuration for AI assistance

            ## Getting started
            ```bash
            nix develop
            # or with direnv
            direnv allow
            ```

            ## Quick start
            ```bash
            uv init                        # Initialize project
            uv add requests                # Add dependency
            uv run python script.py        # Run in venv
            uv run pytest                  # Run tests
            ```

            ## Create a FastAPI project
            ```bash
            uv init my-api && cd my-api
            uv add fastapi uvicorn
            uv run uvicorn main:app --reload
            ```

            See CLAUDE.md for development guidelines and patterns.
          '';
        };
      };
    };
}
