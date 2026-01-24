{
  lib,
  fetchFromGitHub,
  python3,
  writeShellScriptBin,
}:

let
  pname = "perplexity-webui-scraper";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "henrique-coder";
    repo = "perplexity-webui-scraper";
    rev = "0f906678e9c1a0e331a2f87aad58f5a72b900509";
    hash = "sha256-KlJR6w5ZehRmZKI5rlk2/PxrzUYzhZH0oypMfoNDZqY=";
  };

  pythonEnv = python3.withPackages (ps: with ps; [
    pip
    setuptools
    wheel
  ]);

  # Disclaimer for the package
  disclaimer = ''
    ===============================================================================
    NOTICE: This package uses HTTP session tokens to access Perplexity AI.

    Using this tool may violate Perplexity's Terms of Service, which prohibit
    "automation software (bots)" and similar automated access methods.

    This tool requires a Perplexity Pro subscription and extracts session tokens
    from your authenticated browser session.

    Users are responsible for reviewing and complying with:
    - Perplexity's Terms of Service: https://www.perplexity.ai/hub/legal/terms-of-service
    - Perplexity's Acceptable Use Policy: https://www.perplexity.ai/hub/legal/aup

    The upstream project states it is for "educational and experimental purposes only."
    This package is provided "as-is" without warranty. Use at your own risk.
    ===============================================================================
  '';
in
writeShellScriptBin pname ''
  set -e

  # Show disclaimer on first run
  DISCLAIMER_SHOWN="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}/.disclaimer-shown"
  if [ ! -f "$DISCLAIMER_SHOWN" ]; then
    cat << 'EOF'
  ${disclaimer}
  EOF
    mkdir -p "$(dirname "$DISCLAIMER_SHOWN")"
    touch "$DISCLAIMER_SHOWN"
  fi

  # Setup directory
  DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
  VENV_DIR="$DATA_DIR/venv"
  INSTALL_MARKER="$DATA_DIR/.installed-${version}"

  # First-time setup: create venv and install package
  if [ ! -f "$INSTALL_MARKER" ]; then
    echo "First run: Setting up ${pname} v${version}..."
    mkdir -p "$DATA_DIR"

    # Create virtual environment
    ${pythonEnv}/bin/python -m venv "$VENV_DIR" --system-site-packages

    # Install the package from source
    source "$VENV_DIR/bin/activate"
    pip install --quiet "${src}[mcp]"

    touch "$INSTALL_MARKER"
    echo "Setup complete!"
  else
    source "$VENV_DIR/bin/activate"
  fi

  # Run the MCP server
  exec perplexity-webui-scraper-mcp "$@"
'' // {
  meta = {
    description = "Lightweight Perplexity AI scraper via session tokens (ToS warning: see disclaimer)";
    homepage = "https://github.com/henrique-coder/perplexity-webui-scraper";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = pname;
    platforms = lib.platforms.unix;

    longDescription = ''
      A lightweight Python library for interacting with Perplexity AI's web interface
      using session tokens extracted from an authenticated browser session.

      WARNING: This tool may violate Perplexity's Terms of Service. The upstream
      project states it is for "educational and experimental purposes only."
      Users are responsible for ensuring their use complies with applicable terms.

      Features:
      - Lightweight (no browser required, just HTTP requests)
      - MCP server for AI agent integration
      - Requires Perplexity Pro subscription
      - Session token-based authentication

      To get your session token, run: get-perplexity-session-token
    '';
  };
}
