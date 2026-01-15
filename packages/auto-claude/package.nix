{
  lib,
  appimageTools,
  fetchurl,
  python312,
  git,
  gtk3,
  libsecret,
  libGL,
  mesa,
  libgbm,
  alsa-lib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  cups,
  dbus,
  libdrm,
  libxkbcommon,
  pango,
  cairo,
  gdk-pixbuf,
  xorg,
  systemd,
  expat,
}:

let
  pname = "auto-claude";
  version = "2.7.4";

  src = fetchurl {
    url = "https://github.com/AndyMik90/Auto-Claude/releases/download/v${version}/Auto-Claude-${version}-linux-x86_64.AppImage";
    hash = "sha256-8aq8WEv64ZpeEVkEU3+L6n2doP8AFeKM8BcnA+thups=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      # Python environment for backend venv creation
      python312
      python312Packages.pip
      python312Packages.virtualenv
      python312Packages.setuptools

      # Git for Auto-Claude operations
      git

      # Graphics and UI libraries
      gtk3
      libsecret
      libGL
      mesa
      libgbm

      # Audio and system
      alsa-lib
      nss
      nspr
      atk
      at-spi2-atk
      cups
      dbus
      libdrm
      libxkbcommon
      pango
      cairo
      gdk-pixbuf
      expat
      systemd

      # X11 libraries
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      xorg.libxshmfence
    ];

  extraInstallCommands = ''
    # Install desktop file
    install -Dm644 ${appimageContents}/auto-claude-ui.desktop \
      $out/share/applications/${pname}.desktop

    # Install all available icon sizes
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/auto-claude-ui.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done

    # Fix desktop file paths
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
      --replace-fail 'Icon=auto-claude-ui' 'Icon=${pname}'
  '';

  # Electron apps need this to prevent premature termination
  dieWithParent = false;

  meta = {
    description = "Autonomous multi-agent coding framework powered by Claude AI";
    longDescription = ''
      Auto-Claude is an Electron desktop application with Python backend
      for autonomous AI agent workflows.

      The AppImage includes a bundled Python runtime. On first run, it creates
      a virtual environment in ~/.config/auto-claude-ui/python-venv and
      installs required Python packages (claude-agent-sdk, python-dotenv, etc.).
    '';
    homepage = "https://github.com/AndyMik90/Auto-Claude";
    downloadPage = "https://github.com/AndyMik90/Auto-Claude/releases";
    changelog = "https://github.com/AndyMik90/Auto-Claude/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gui-wf ];
    mainProgram = "auto-claude";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
