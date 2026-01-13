{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  fetchPnpmDeps,
  nodejs,
  python3,
}:

buildNpmPackage rec {
  pname = "markdownify-mcp-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gui-wf";
    repo = "markdownify-mcp-utf8";
    rev = "5223556c4c3d5f6f0f34537e68ef06c86ecd962c"; # feat: add Nix flake
    hash = "sha256-EhJTaobOL9xCUfMd1EBw6k13rWjF0Xp7CZXMw0DYO8k=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    hash = "sha256-OLq1z0ue6I7CRNYHMVlBOqzfgIQF1+KEFvJlPLy+jfQ=";
  };

  nativeBuildInputs = [
    nodejs
    python3.pkgs.uv
  ];

  # Remove broken symlink dependency before building
  preBuild = ''
    # Remove the broken link: dependency from package.json
    sed -i '/"sdk":/d' package.json
  '';

  # Ensure uv is in PATH for the wrapper script
  postInstall = ''
    wrapProgram $out/bin/mcp-markdownify-server \
      --prefix PATH : ${lib.makeBinPath [ python3.pkgs.uv ]}
  '';

  meta = {
    description = "MCP server that converts various file formats to Markdown using markitdown";
    homepage = "https://github.com/gui-wf/markdownify-mcp-utf8";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gui-wf ];
    mainProgram = "mcp-markdownify-server";
    platforms = lib.platforms.unix;
  };
}
