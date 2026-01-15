{
  lib,
  stdenv,
  callPackage,
  fetchurl,
}:

let
  pname = "auto-claude";
  version = "2.7.4";

  # Platform-specific sources
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/AndyMik90/Auto-Claude/releases/download/v${version}/Auto-Claude-${version}-linux-x86_64.AppImage";
      hash = "sha256-8aq8WEv64ZpeEVkEU3+L6n2doP8AFeKM8BcnA+thups=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/AndyMik90/Auto-Claude/releases/download/v${version}/Auto-Claude-${version}-darwin-x64.dmg";
      hash = "sha256-MchnS6lgHYomM5NTga/aD+ll8Tp4rQubW/B1OXqHlP4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/AndyMik90/Auto-Claude/releases/download/v${version}/Auto-Claude-${version}-darwin-arm64.dmg";
      hash = "sha256-SlxAO0cAVXYIqvwwwyWGrMX2Rzu7fViMHGkzNEpeKuo=";
    };
  };

  src =
    sources.${stdenv.hostPlatform.system} or (throw "auto-claude: unsupported system ${stdenv.hostPlatform.system}");

  meta = {
    description = "Autonomous multi-agent coding framework powered by Claude AI";
    longDescription = ''
      Auto-Claude is an Electron desktop application with Python backend
      for autonomous AI agent workflows.

      On Linux, uses AppImage with bundled Python. On macOS, installs as
      a native .app bundle. Creates Python venv in userData on first run.
    '';
    homepage = "https://github.com/AndyMik90/Auto-Claude";
    downloadPage = "https://github.com/AndyMik90/Auto-Claude/releases";
    changelog = "https://github.com/AndyMik90/Auto-Claude/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gui-wf ];
    mainProgram = "auto-claude";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  # Platform dispatch
  platformPackage = if stdenv.hostPlatform.isLinux then ./linux.nix else ./darwin.nix;
in
callPackage platformPackage {
  inherit
    pname
    version
    src
    meta
    ;
}
