{
  description = "MCP Server Template - TypeScript-based Model Context Protocol server";

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
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core utilities
            wget
            yq
            jq
            curl
            tree

            # Runtime environments
            nodejs_20
            nodePackages.npm
            nodePackages.typescript
            nodePackages.typescript-language-server

            # Secrets management
            sops
            age
          ];

          shellHook = ''
            # Decrypt MCP environment if it exists
            if [ -f ./.mcp.env.enc ]; then
              sops -d ./.mcp.env.enc > .env.mcp 2>/dev/null || echo "⚠️  Could not decrypt .mcp.env.enc"
            fi

            echo "🔧 MCP Server Development Environment"
            echo ""
            echo "Node.js: $(node --version)"
            echo "npm: $(npm --version)"
            echo "TypeScript: $(tsc --version)"
            echo ""
            echo "Quick Start:"
            echo "  1. npm install          - Install dependencies"
            echo "  2. npm run dev          - Run server in development mode"
            echo "  3. npm run inspector    - Test with MCP Inspector"
            echo ""
            echo "See CLAUDE.md for detailed documentation"
          '';
        };

        # Production package (update after creating package.json)
        packages.default = pkgs.buildNpmPackage {
          pname = "my-mcp-server";
          version = "1.0.0";
          src = ./.;

          # AIDEV-TODO: Update npmDepsHash after first build - run: nix build 2>&1 | grep "got:" | awk '{print $2}'
          npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

          buildPhase = ''
            npm run build
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/{bin,lib}

            # Copy compiled code and dependencies
            cp -r dist $out/lib/
            cp -r node_modules $out/lib/
            cp package.json $out/lib/

            # Create executable wrapper
            cat > $out/bin/my-mcp-server <<EOF
            #!/usr/bin/env bash
            exec ${pkgs.nodejs_20}/bin/node $out/lib/dist/index.js "\$@"
            EOF
            chmod +x $out/bin/my-mcp-server

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "MCP server description";
            license = licenses.mit;
          };
        };

        # App for running the server
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/my-mcp-server";
        };
      }
    );
}
