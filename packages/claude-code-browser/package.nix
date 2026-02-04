{
  lib,
  fetchFromGitHub,
  python3,
  writeShellScriptBin,
  writeTextDir,
  symlinkJoin,
}:

let
  pname = "claude-code-browser";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nanogenomic";
    repo = "ClaudeCodeBrowser";
    rev = "3bf4a83ca0f70849142065cb6a993efcc7fe760b"; # HEAD as of 2026-02
    hash = "sha256-GLfet+EhCDidKLoj/k7gw/PyOkvcJbPNPPb26uOBkpk=";
  };

  pythonEnv = python3.withPackages (ps: with ps; [
    websockets
  ]);

  # Main MCP server script wrapper
  serverScript = writeShellScriptBin pname ''
    set -e

    # Setup data directory
    DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
    SCREENSHOTS_DIR="''${CLAUDE_BROWSER_SCREENSHOTS_DIR:-$DATA_DIR/screenshots}"
    INSTALL_MARKER="$DATA_DIR/.installed-${version}"

    # Environment defaults
    export CLAUDE_BROWSER_HOST="''${CLAUDE_BROWSER_HOST:-127.0.0.1}"
    export CLAUDE_BROWSER_HTTP_PORT="''${CLAUDE_BROWSER_HTTP_PORT:-8765}"
    export CLAUDE_BROWSER_WS_PORT="''${CLAUDE_BROWSER_WS_PORT:-8766}"
    export CLAUDE_BROWSER_SCREENSHOTS_DIR="$SCREENSHOTS_DIR"

    # First-time setup
    if [ ! -f "$INSTALL_MARKER" ]; then
      echo "First run: Setting up ${pname} v${version}..."
      mkdir -p "$DATA_DIR"
      mkdir -p "$SCREENSHOTS_DIR"

      # Copy source to data directory for Firefox extension access
      rm -rf "$DATA_DIR/src"
      cp -r ${src} "$DATA_DIR/src"
      chmod -R u+w "$DATA_DIR/src"

      touch "$INSTALL_MARKER"
      echo ""
      echo "Setup complete!"
      echo ""
      echo "IMPORTANT: Firefox extension setup required:"
      echo "  1. Open Firefox and navigate to: about:debugging#/runtime/this-firefox"
      echo "  2. Click 'Load Temporary Add-on...'"
      echo "  3. Select: $DATA_DIR/src/extension/manifest.json"
      echo "  4. The extension will load (needs reloading after Firefox restart)"
      echo ""
      echo "For permanent extension installation, see:"
      echo "  https://github.com/nanogenomic/ClaudeCodeBrowser#installation"
      echo ""
    fi

    # Run the MCP server via stdio wrapper (bridges Claude Code stdio to HTTP server)
    exec ${pythonEnv}/bin/python "$DATA_DIR/src/mcp-server/stdio_wrapper.py" "$@"
  '';

  # Provide MCP config template for users
  mcpConfigTemplate = writeTextDir "share/${pname}/mcp-config.json" (builtins.toJSON {
    mcpServers = {
      claudecodebrowser = {
        type = "stdio";
        command = "${serverScript}/bin/${pname}";
        args = [ ];
      };
    };
  });

in
symlinkJoin {
  name = pname;
  paths = [ serverScript mcpConfigTemplate ];

  meta = {
    description = "Firefox browser automation MCP server for Claude Code";
    homepage = "https://github.com/nanogenomic/ClaudeCodeBrowser";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = pname;
    platforms = lib.platforms.linux;

    longDescription = ''
      ClaudeCodeBrowser is a Firefox browser automation system for Claude Code.
      It provides MCP (Model Context Protocol) tools for:

      - Screenshot capture (visible or full-page)
      - Element interaction (click, type, scroll, hover)
      - Navigation (URLs, tabs, page refresh)
      - Element inspection and JavaScript execution
      - Console and network monitoring
      - Tab management

      SETUP REQUIRED: After first run, you must manually load the Firefox
      extension via about:debugging#/runtime/this-firefox.

      The extension polls an HTTP server (port 8765 by default) and executes
      browser commands. See the GitHub repo for detailed setup instructions.
    '';
  };
}
