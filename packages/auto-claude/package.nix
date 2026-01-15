{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  python312,
  git,
  gtk3,
  libsecret,
  libGL,
  mesa,
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
  libgbm,
}:

let
  pname = "auto-claude";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "AndyMik90";
    repo = "Auto-Claude";
    rev = "v${version}";
    hash = "sha256-7IPGleVU9EaYQuRQlKVApt/jItMpLRSaIxpN8KSoyIY=";
  };

  # Provide Node.js 24 and Python 3.12
  nodejsEnv = nodejs_24;
  pythonEnv = python312.withPackages (ps: with ps; [
    pip
    virtualenv
    setuptools
    wheel
  ]);

in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
    nodejsEnv
    pythonEnv
    git
  ];

  # Don't build during nix build - we'll do it on first run
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    # Install source to $out/share
    mkdir -p $out/share/${pname}
    cp -r . $out/share/${pname}/

    # Create wrapper script
    mkdir -p $out/bin
    cat > $out/bin/${pname} <<'EOF'
#!/usr/bin/env bash
set -e

# Setup directories
INSTALL_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/auto-claude"
INITIALIZED="$INSTALL_DIR/.initialized"

# Initialize on first run
if [ ! -f "$INITIALIZED" ]; then
  echo "First run: Setting up Auto-Claude..."
  echo "This will take a few minutes..."

  mkdir -p "$INSTALL_DIR"
  cd "$INSTALL_DIR"

  # Copy source if not already there
  if [ ! -f "package.json" ]; then
    cp -r @out@/share/@pname@/* .
    chmod -R u+w .
  fi

  # Install Node.js dependencies
  echo "Installing Node.js dependencies..."
  @nodejs@/bin/npm install --no-save --prefer-offline

  # Setup Python backend
  echo "Setting up Python backend..."
  cd apps/backend
  @python@/bin/python -m venv .venv
  source .venv/bin/activate
  pip install -r requirements.txt
  cd ../..

  touch "$INITIALIZED"
  echo "Setup complete!"
fi

# Run the application
cd "$INSTALL_DIR"
export PATH="@nodejs@/bin:@python@/bin:@git@/bin:$PATH"
export NODE_PATH="$INSTALL_DIR/node_modules"
export LD_LIBRARY_PATH="@libPath@:$LD_LIBRARY_PATH"

# Activate Python venv
source "$INSTALL_DIR/apps/backend/.venv/bin/activate"

# Run Electron app
exec @nodejs@/bin/npm start -- "$@"
EOF

    chmod +x $out/bin/${pname}

    # Build library path for Electron
    libPath="${lib.makeLibraryPath [
      gtk3
      libsecret
      libGL
      mesa
      libgbm
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
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      xorg.libxshmfence
      systemd
    ]}"

    # Substitute paths
    substituteInPlace $out/bin/${pname} \
      --replace '@out@' "$out" \
      --replace '@pname@' "${pname}" \
      --replace '@nodejs@' "${nodejsEnv}" \
      --replace '@python@' "${pythonEnv}" \
      --replace '@git@' "${git}" \
      --replace '@libPath@' "$libPath"

    runHook postInstall
  '';

  meta = {
    description = "Autonomous multi-agent coding framework powered by Claude AI";
    longDescription = ''
      Auto-Claude is an Electron desktop application with Python backend
      for autonomous AI agent workflows. This wrapper sets up dependencies
      on first run and manages the application in user space.
    '';
    homepage = "https://github.com/AndyMik90/Auto-Claude";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gui-wf ];
    mainProgram = "auto-claude";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
