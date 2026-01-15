{
  pname,
  version,
  src,
  meta,
  lib,
  appimageTools,
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

  # Set APPIMAGE env var so Auto-Claude detects it's running as AppImage
  extraBwrapArgs = [
    "--setenv APPIMAGE /tmp/auto-claude.AppImage"
  ];

  meta = meta // {
    platforms = [ "x86_64-linux" ];
  };
}
