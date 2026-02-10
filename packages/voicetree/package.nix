{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "voicetree";
  version = "2.4.15";

  src = fetchurl {
    url = "https://github.com/voicetreelab/voicetree/releases/download/v${version}/voicetree.AppImage";
    hash = "sha256-ijM4jW8aRzAnGdP/lyxP+mDWuCzZCp2sJnKoUrATZoM=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/voicetree-webapp.desktop $out/share/applications/voicetree.desktop

    substituteInPlace $out/share/applications/voicetree.desktop \
      --replace-warn 'Exec=AppRun --no-sandbox %U' 'Exec=voicetree %U'

    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = with lib; {
    description = "Spatial IDE for multi-agent orchestration";
    homepage = "https://github.com/voicetreelab/voicetree";
    license = licenses.bsl11;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "voicetree";
  };
}
