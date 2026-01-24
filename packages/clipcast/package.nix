{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcast";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "alfa07";
    repo = "clipcast";
    rev = "v${version}";
    hash = "sha256-aXrdSWkY7R6LGYe+p/Jm4ya//m1EzdaxjKheoQr2MhI=";
  };

  cargoHash = "sha256-gl7xl/Q6l78AwZDZ9wplOolxfuUtWQjViyxadMD6UNM=";

  # clipcast doesn't have shell completion generation yet

  meta = {
    description = "Bidirectional clipboard synchronization over SSH";
    longDescription = ''
      Clipcast enables real-time clipboard sharing between local and remote
      machines over SSH. Features include automatic reconnection, ping/pong
      health checks, and customizable clipboard commands for different platforms.
    '';
    homepage = "https://github.com/alfa07/clipcast";
    changelog = "https://github.com/alfa07/clipcast/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "clipcast";
    platforms = lib.platforms.unix;
  };
}
