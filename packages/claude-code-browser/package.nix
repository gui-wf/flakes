{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

let
  pname = "claude-code-browser";
  version = "0-unstable-2026-02-05";

  # Using fork with HTTP polling fix until upstream merges PR#1
  # https://github.com/nanogenomic/ClaudeCodeBrowser/pull/1
  src = fetchFromGitHub {
    owner = "gui-wf";
    repo = "ClaudeCodeBrowser";
    rev = "49551773a96a6f59a5263eb23d954d299d9affa7";
    hash = "sha256-QrHaEXKgtMsTdIzqHIYoqZ/XQq2POhFOdmt81hFy0kI=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.websockets ]);

in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    # MCP Server files
    mkdir -p $out/lib/claudecodebrowser/mcp-server
    cp mcp-server/server.py $out/lib/claudecodebrowser/mcp-server/
    cp mcp-server/stdio_wrapper.py $out/lib/claudecodebrowser/mcp-server/
    test -f mcp-server/mcp_config.json && cp mcp-server/mcp_config.json $out/lib/claudecodebrowser/mcp-server/

    # Native host files
    mkdir -p $out/lib/claudecodebrowser/native-host
    cp native-host/claudecodebrowser_host.py $out/lib/claudecodebrowser/native-host/

    # Agent files
    mkdir -p $out/lib/claudecodebrowser/agent
    cp agent/browser_agent.py $out/lib/claudecodebrowser/agent/

    # Extension (for manual installation in Firefox)
    mkdir -p $out/share/claudecodebrowser/extension
    cp -r extension/* $out/share/claudecodebrowser/extension/

    # Wrapper scripts in bin/
    mkdir -p $out/bin

    # HTTP server (runs persistently)
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/claudecodebrowser-server \
      --add-flags "$out/lib/claudecodebrowser/mcp-server/server.py"

    # Stdio wrapper (bridges Claude Code stdio to HTTP server)
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/claudecodebrowser-stdio \
      --add-flags "$out/lib/claudecodebrowser/mcp-server/stdio_wrapper.py"

    # Native messaging host (for Firefox extension)
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/claudecodebrowser-native-host \
      --add-flags "$out/lib/claudecodebrowser/native-host/claudecodebrowser_host.py"

    # Browser agent CLI
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/claudecodebrowser-agent \
      --add-flags "$out/lib/claudecodebrowser/agent/browser_agent.py"

    runHook postInstall
  '';

  passthru = {
    inherit pythonEnv;
    # Paths for home-manager module to reference
    serverScript = "lib/claudecodebrowser/mcp-server/server.py";
    stdioScript = "lib/claudecodebrowser/mcp-server/stdio_wrapper.py";
    nativeHostScript = "lib/claudecodebrowser/native-host/claudecodebrowser_host.py";
    extensionPath = "share/claudecodebrowser/extension";
  };

  meta = {
    description = "Firefox browser automation MCP server for Claude Code";
    homepage = "https://github.com/nanogenomic/ClaudeCodeBrowser";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "claudecodebrowser-server";
  };
}
