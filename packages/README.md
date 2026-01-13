# Packages Directory

This directory contains reusable Nix packages that are automatically discovered and exposed as flake outputs.

## How It Works

The flake automatically discovers packages using `builtins.readDir` and `lib.mapAttrs`:
1. Scans this `packages/` directory for subdirectories
2. Each subdirectory must contain either `package.nix` or `default.nix`
3. Packages are imported with `pkgs.callPackage` and exposed as `packages.<name>`

## Adding a New Package

Simply create a new directory with your package definition:

```bash
mkdir -p packages/my-package
cat > packages/my-package/package.nix <<'EOF'
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "my-package";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "example";
    repo = "my-package";
    rev = "v${version}";
    hash = "sha256-...";
  };

  meta = {
    description = "My awesome package";
    homepage = "https://github.com/example/my-package";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
EOF
```

The package will automatically be available as:
- `nix build .#my-package`
- `nix run .#my-package` (if it has a binary)
- `packages.my-package` in other flakes

## Package Naming

- Use lowercase names with hyphens: `my-package`, not `MyPackage` or `my_package`
- Match the upstream project name when possible
- Keep names concise and descriptive

## Testing Packages

```bash
# Build a package
nix build .#my-package

# Run a package (if it's executable)
nix run .#my-package

# Check package metadata
nix eval .#packages.x86_64-linux.my-package.meta
```

## Current Packages

- **auto-claude**: Autonomous multi-agent coding framework powered by Claude AI

## Why This Approach?

**Benefits:**
- **Zero boilerplate**: No need to manually list packages in flake.nix
- **Automatic discovery**: Add a directory, it's instantly available
- **Consistent structure**: All packages follow the same pattern
- **Easy maintenance**: No central registry to update

**Pattern:**
```nix
packages =
  let
    packagesDir = ./packages;
    entries = builtins.readDir packagesDir;
    packageDirs = lib.filterAttrs (name: type:
      type == "directory" &&
      (pathExists (packagesDir + "/${name}/package.nix") ||
       pathExists (packagesDir + "/${name}/default.nix"))
    ) entries;
  in
    lib.mapAttrs (name: _:
      pkgs.callPackage (packagesDir + "/${name}") {}
    ) packageDirs;
```

This leverages Nix's powerful built-in functions for dynamic filesystem introspection.
