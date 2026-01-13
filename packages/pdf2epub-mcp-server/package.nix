{
  lib,
  fetchFromGitHub,
  python3,
  writeShellScriptBin,
  makeWrapper,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      transformers
      markdown
      pillow
      regex
      torch
      pip
      setuptools
      wheel
      numpy
      scipy
      scikit-learn
      tqdm
      requests
      pyyaml
      filelock
      huggingface-hub
      tokenizers
      safetensors
      pdfminer-six
      pypdf2
      pytesseract
      pdf2image
    ]
  );

  src = fetchFromGitHub {
    owner = "gui-wf";
    repo = "pdf2epub-mcp-server";
    rev = "3a39508ad1aae00d12de7c84b00e1a9baf7da2bf"; # feat: add Nix flake
    hash = "sha256-NJ1VnpZ4pE6PpcyHcMDJp4WUOXNLBKmtVcF9m/vWBfM=";
  };
in
writeShellScriptBin "pdf2epub-mcp-server" ''
  VENV_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/pdf2epub/venv"
  MARKER_INSTALLED="$VENV_DIR/.marker-installed"

  if [ ! -f "$MARKER_INSTALLED" ]; then
    echo "First run: Setting up pdf2epub environment..."
    mkdir -p "$(dirname "$VENV_DIR")"
    ${pythonEnv}/bin/python -m venv "$VENV_DIR" --system-site-packages
    source "$VENV_DIR/bin/activate"
    pip install --quiet marker-pdf==0.3.10
    touch "$MARKER_INSTALLED"
    echo "Setup complete!"
  else
    source "$VENV_DIR/bin/activate"
  fi

  exec python ${src}/main.py "$@"
''
