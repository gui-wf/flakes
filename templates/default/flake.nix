{
  description = "General-purpose development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Example package: a simple bash script that uses jq as a dependency
        hello-script = pkgs.writeShellScriptBin "hello-script" ''
          #!/usr/bin/env bash
          
          # This is an example script that demonstrates:
          # 1. A basic bash script as a Nix package
          # 2. Using other packages as dependencies (jq in this case)
          
          echo "🚀 Hello from your Nix flake template!"
          echo "Current working directory: $(pwd)"
          echo "Available tools in this environment:"
          
          # Example of using jq (one of our dependencies)
          echo '{"message": "This JSON was formatted with jq", "tools": ["wget", "yq", "jq", "nodejs", "python3"]}' | ${pkgs.jq}/bin/jq .
          
          echo ""
          echo "✨ You can modify this script in flake.nix"
          echo "   or create your own packages and apps!"
        '';
      in
      {
        # Packages that can be built
        packages.default = hello-script;
        
        # Apps that can be run with 'nix run'
        apps.default = {
          type = "app";
          program = "${hello-script}/bin/hello-script";
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
            nodePackages.npm
            python3
            python3Packages.pip
            
            # Development tools
            git
            curl
            tree
            
            # Code editors and tools
            nano
            vim
            
            # Make our example script available in the dev shell
            hello-script
          ];
          
          shellHook = ''
            echo "🧊 General Purpose Development Environment"
            echo "Node.js: $(node --version)"
            echo "Python: $(python --version)"
            echo "npm: $(npm --version)"
            echo ""
            echo "📦 Example package available: hello-script"
            echo "🏃 Try: nix run (or just 'hello-script' in this shell)"
            echo "🛠️  This demonstrates how to create packages and apps in Nix flakes"
          '';
        };
      }
    );
}