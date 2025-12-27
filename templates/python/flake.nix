{
  description = "Python development environment with uv and venv";

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

            # Python with venv support
            (with python3.pkgs; [
              python
              venvShellHook
              wheel
            ])

            # Modern Python package manager
            uv

            # Development tools
            git
            curl
            tree

            # Language servers
            python3Packages.python-lsp-server
          ];

          venvDir = "./.venv";

          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            # Auto-sync if pyproject.toml exists
            if [ -f pyproject.toml ]; then
              uv sync
            fi
          '';

          postShellHook = ''
            # Sync dependencies if pyproject.toml exists
            if [ -f pyproject.toml ]; then
              uv sync
            fi

            # Set up Python environment
            export PYTHONPATH="$PWD:$PYTHONPATH"

            # Display environment info
            PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
            UV_VERSION=$(uv --version 2>&1 | awk '{print $2}')

            echo "Python Development Environment"
            echo "Python: $PYTHON_VERSION"
            echo "uv: $UV_VERSION"
            echo "venv: ./.venv"
            echo ""
            echo "Available commands:"
            echo "  uv sync          - Install dependencies from pyproject.toml"
            echo "  uv add <pkg>     - Add a dependency"
            echo "  uv run <cmd>     - Run command in venv"
            echo "  uv run pytest    - Run tests"
            echo ""
          '';
        };
      }
    );
}
