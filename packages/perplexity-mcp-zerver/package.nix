{
  lib,
  fetchFromGitHub,
  writeShellScriptBin,
  bun,
  chromium,
  makeWrapper,
}:

let
  pname = "perplexity-mcp-zerver";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "wysh3";
    repo = "perplexity-mcp-zerver";
    rev = "3e316abed14c28af2e4dbd1b0ce510c56b396e40";
    hash = "sha256-a8ceCf/p4hiCS/uPc6ihye6CCKALMSWWzO5KyQS/JW4=";
  };

  # Disclaimer for the package
  disclaimer = ''
    ===============================================================================
    NOTICE: This package uses browser automation to interface with Perplexity AI.

    Using this tool may violate Perplexity's Terms of Service, which prohibit
    "automation software (bots)" and similar automated access methods.

    Users are responsible for reviewing and complying with:
    - Perplexity's Terms of Service: https://www.perplexity.ai/hub/legal/terms-of-service
    - Perplexity's Acceptable Use Policy: https://www.perplexity.ai/hub/legal/aup

    The upstream project states it is for "educational use only."
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

  # Setup directory for the MCP server
  DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
  INSTALL_MARKER="$DATA_DIR/.installed-${version}"

  # Configure Puppeteer to use Nix's Chromium
  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
  export PUPPETEER_EXECUTABLE_PATH="${chromium}/bin/chromium"

  # First-time setup: install dependencies
  if [ ! -f "$INSTALL_MARKER" ]; then
    echo "First run: Setting up ${pname} v${version}..."
    mkdir -p "$DATA_DIR"

    # Copy source to data directory
    rm -rf "$DATA_DIR/src"
    cp -r ${src} "$DATA_DIR/src"
    chmod -R u+w "$DATA_DIR/src"

    # Install dependencies with Bun
    cd "$DATA_DIR/src"
    ${bun}/bin/bun install --frozen-lockfile 2>/dev/null || ${bun}/bin/bun install

    # Build TypeScript
    ${bun}/bin/bun run build

    touch "$INSTALL_MARKER"
    echo "Setup complete!"
  fi

  cd "$DATA_DIR/src"
  exec ${bun}/bin/bun run build/main.js "$@"
'' // {
  meta = {
    description = "MCP server for Perplexity AI using browser automation (ToS warning: see disclaimer)";
    homepage = "https://github.com/wysh3/perplexity-mcp-zerver";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = pname;
    platforms = lib.platforms.linux; # Chromium/Puppeteer works best on Linux

    # Long description with full disclaimer
    longDescription = ''
      An MCP (Model Context Protocol) server that provides AI-powered research
      capabilities through browser automation of Perplexity's web interface.

      WARNING: This tool uses browser automation which may violate Perplexity's
      Terms of Service. The upstream project states it is for "educational use only."
      Users are responsible for ensuring their use complies with applicable terms.

      Features:
      - Intelligent web research with deep searches and detailed summaries
      - Persistent conversations with local SQLite chat storage
      - Content extraction for URLs and GitHub repositories
      - No API key required (uses browser automation)
    '';
  };
}
