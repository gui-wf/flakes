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

  sourceRoot = "Auto-Claude.app";

  installPhase = ''
    runHook preInstall

    # Install .app bundle to Applications
    mkdir -p "$out/Applications/Auto-Claude.app"
    cp -R . "$out/Applications/Auto-Claude.app"

    # Create CLI wrapper for terminal usage
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/Auto-Claude.app/Contents/MacOS/Auto-Claude" "$out/bin/${pname}" \
      --chdir "$out/Applications/Auto-Claude.app/Contents/Resources"

    runHook postInstall
  '';

  # Preserve code signature for notarized app
  dontFixup = true;

  meta = meta // {
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
