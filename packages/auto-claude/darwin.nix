{
  pname,
  version,
  src,
  meta,
  stdenvNoCC,
  undmg,
  makeWrapper,
}:

stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    # Install .app bundle to Applications
    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications/"

    # Create CLI wrapper using open command (standard macOS approach)
    mkdir -p "$out/bin"
    cat > "$out/bin/${pname}" << 'EOF'
#!/bin/sh
exec open -a "$out/Applications/Auto-Claude.app" --args "$@"
EOF
    chmod +x "$out/bin/${pname}"

    substituteInPlace "$out/bin/${pname}" --replace '$out' "$out"

    runHook postInstall
  '';

  # Preserve code signature for notarized app
  dontStrip = true;
  dontPatchShebangs = true;

  meta = meta // {
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
