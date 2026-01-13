# Implementation Analysis: Dynamic Flake Improvements

## Overview

This document explains the refactoring from a static, manually-maintained flake to a dynamic, auto-discovering system using Nix's built-in capabilities.

## Problems with Original Approach

### 1. **Manual Template Registration (310 lines → 150 lines)**

**Before:**
```nix
templates = {
  default = {
    path = ./templates/default;
    description = "General-purpose development environment...";
    welcomeText = ''
      # Development Template
      This template provides...
      (50+ lines per template)
    '';
  };
  blender = { ... };  # Repeat for each template
  zola = { ... };
  # 7 templates × 40-50 lines each = ~300 lines
};
```

**Problems:**
- Adding a template requires editing flake.nix (two places: definition + shellHook list)
- Description and welcomeText duplicated from template's own docs
- Easy to forget to update the list
- Violates DRY (Don't Repeat Yourself) principle

### 2. **No Package Outputs**

The flake didn't expose any reusable packages, only templates and devShells.

### 3. **No Auto-Discovery**

Everything was hardcoded, making it tedious to add new templates or packages.

---

## Solutions Implemented

### 1. **Auto-Discover Templates**

**Pattern Used:**
```nix
discoverTemplates =
  let
    templatesDir = ./templates;
    entries = builtins.readDir templatesDir;  # Read directory contents

    # Filter only directories (type == "directory")
    templateDirs = lib.filterAttrs (_: type: type == "directory") entries;

    # Map each directory to a template definition
    makeTemplate = name: _:
      let
        templatePath = templatesDir + "/${name}";
        metadata = readTemplateMetadata templatePath;
      in
      {
        path = templatePath;
        description = metadata.description;
        welcomeText = metadata.welcomeText;
      };
  in
    lib.mapAttrs makeTemplate templateDirs;
```

**Key Functions:**
- `builtins.readDir ./templates` → Returns `{ default = "directory"; blender = "directory"; ... }`
- `lib.filterAttrs` → Keeps only directories (ignores files)
- `lib.mapAttrs` → Transforms each entry into a template definition

**Benefits:**
- **Zero maintenance**: Add a directory to `templates/`, it's instantly available
- **Self-documenting**: Metadata extracted from template files
- **Type-safe**: Only directories are processed
- **Reduced LOC**: 300 lines → ~50 lines

### 2. **Auto-Discover Packages**

**Pattern Used:**
```nix
discoverPackages = system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    packagesDir = ./packages;
  in
    if builtins.pathExists packagesDir then
      let
        entries = builtins.readDir packagesDir;

        # Filter directories with package.nix or default.nix
        packageDirs = lib.filterAttrs (name: type:
          type == "directory" &&
          (builtins.pathExists (packagesDir + "/${name}/package.nix") ||
           builtins.pathExists (packagesDir + "/${name}/default.nix"))
        ) entries;

        # Import each package with callPackage
        importPackage = name: _:
          let
            packagePath = packagesDir + "/${name}";
            packageFile =
              if builtins.pathExists (packagePath + "/package.nix")
              then packagePath + "/package.nix"
              else packagePath + "/default.nix";
          in
            pkgs.callPackage packageFile {};
      in
        lib.mapAttrs importPackage packageDirs
    else {};
```

**Key Functions:**
- `builtins.pathExists` → Check if directories/files exist
- `builtins.readDir` → Read package directory contents
- `lib.filterAttrs` → Filter for valid package directories
- `pkgs.callPackage` → Import package with automatic dependency injection

**Benefits:**
- **Automatic exposure**: Packages instantly available as `packages.<name>`
- **Convention over configuration**: Just follow `package.nix` or `default.nix` pattern
- **Fail-safe**: If `packages/` doesn't exist, returns empty set
- **Flexible**: Supports both `package.nix` and `default.nix` conventions

### 3. **Dynamic Metadata Extraction**

**Pattern Used:**
```nix
readTemplateMetadata = templatePath:
  let
    flakeFile = templatePath + "/flake.nix";
    flakeContent = builtins.readFile flakeFile;

    # Extract description using regex matching
    descMatch = builtins.match ".*description = \"([^\"]+)\".*" flakeContent;
    description =
      if descMatch != null
      then builtins.head descMatch
      else "Development environment template";

    # Extract welcomeText from docs
    claudeFile = templatePath + "/CLAUDE.md";
    welcomeText =
      if builtins.pathExists claudeFile
      then let content = builtins.readFile claudeFile;
           in builtins.substring 0 500 content + "\n\nFor full docs..."
      else "See template files for documentation.";
  in
    { inherit description welcomeText; };
```

**Key Functions:**
- `builtins.readFile` → Read file contents as string
- `builtins.match` → Regex pattern matching
- `builtins.substring` → Extract substring (for previews)
- `builtins.pathExists` → Check file existence

**Benefits:**
- **Single source of truth**: Description lives in template's flake.nix
- **Automatic previews**: First 500 chars of docs shown
- **Graceful fallback**: Default values if files missing
- **Maintainability**: Update template docs, flake automatically reflects it

---

## Technical Deep Dive: Nix Built-ins Used

### 1. `builtins.readDir path`

Returns directory contents as an attribute set:

```nix
builtins.readDir ./templates
# → { default = "directory"; blender = "directory"; nodejs = "directory"; ... }
```

**File types:**
- `"regular"` - Regular file
- `"directory"` - Directory
- `"symlink"` - Symbolic link
- `"unknown"` - Unknown type

### 2. `lib.filterAttrs predicate attrset`

Filters attribute set based on predicate function:

```nix
lib.filterAttrs (name: type: type == "directory") entries
# Keeps only entries where type == "directory"
```

### 3. `lib.mapAttrs fn attrset`

Transforms each attribute:

```nix
lib.mapAttrs (name: value: transformFn name value) entries
# Applies transformFn to each entry, returns new attrset
```

### 4. `builtins.pathExists path`

Checks if path exists (file or directory):

```nix
if builtins.pathExists ./packages then ... else ...
# Safe path checking before operations
```

### 5. `builtins.match regex string`

Pattern matching with regex:

```nix
builtins.match ".*description = \"([^\"]+)\".*" content
# Returns list of capture groups or null
```

### 6. `builtins.readFile path`

Reads entire file as string:

```nix
builtins.readFile ./template/CLAUDE.md
# Returns file contents
```

---

## Directory Structure

```
flakes/
├── flake.nix                    # Dynamic flake (150 lines, was 310)
├── flake.lock
├── README.md
├── IMPLEMENTATION_ANALYSIS.md   # This file
│
├── packages/                    # NEW: Auto-discovered packages
│   ├── README.md
│   └── auto-claude/
│       └── package.nix
│
└── templates/                   # Auto-discovered templates
    ├── default/
    │   ├── flake.nix           # Description extracted from here
    │   ├── CLAUDE.md           # WelcomeText extracted from here
    │   └── .envrc
    ├── blender/
    ├── nodejs/
    ├── python/
    ├── zola/
    ├── zola-blog-init/
    └── mcp-server/
```

---

## Usage Examples

### Adding a New Template

**Before:**
1. Create `templates/my-template/`
2. Edit `flake.nix` to add template definition (40-50 lines)
3. Update shellHook to include template name
4. Remember to update README

**After:**
1. Create `templates/my-template/`
2. Done! Automatically discovered and exposed

### Adding a New Package

**Before:**
Not possible - flake didn't expose packages

**After:**
```bash
mkdir -p packages/my-package
cat > packages/my-package/package.nix <<EOF
{ lib, stdenv }:
stdenv.mkDerivation {
  pname = "my-package";
  version = "1.0.0";
  # ...
}
EOF

# Instantly available:
nix build .#my-package
nix run .#my-package
```

### Using in Other Flakes

```nix
{
  inputs.my-flakes.url = "github:gui-wf/flakes";

  outputs = { self, nixpkgs, my-flakes }: {
    packages.x86_64-linux.default =
      my-flakes.packages.x86_64-linux.auto-claude;
  };
}
```

---

## Performance Considerations

### Build-Time Evaluation

All discovery happens at **evaluation time**, not build time:
- `builtins.readDir` is evaluated once when flake is loaded
- Results are cached by Nix
- No runtime overhead

### Flake Purity

Flakes run in **pure evaluation mode**:
- `builtins.readDir` only works on paths in the flake
- External paths require `--impure` flag (not recommended)
- This ensures reproducibility

### Limitations

1. **Static paths only**: `readDir` requires literal paths (no dynamic strings)
2. **No symlink traversal**: Symlinks to derivations fail in pure mode
3. **Evaluation-time only**: Can't discover files during build

---

## Real-World Examples

### 1. **nixos-generators**

Uses `readDir` to auto-discover format modules:

```nix
formats = lib.mapAttrs' (file: _: {
  name = lib.removeSuffix ".nix" file;
  value.imports = [ (./formats + "/${file}") ./format-module.nix ];
}) (builtins.readDir ./formats);
```

[Source: nixos-generators/flake.nix](https://github.com/nix-community/nixos-generators/blob/master/flake.nix)

### 2. **dream2nix**

Filters directories using `readDir`:

```nix
moduleKinds = filterAttrs (_: type: type == "directory") (readDir modulesDir);
```

[Source: dream2nix/flake.nix](https://github.com/nix-community/dream2nix/blob/main/flake.nix)

### 3. **nixpkgs lib/filesystem.nix**

Recursively lists files:

```nix
listFilesRecursive = dir:
  lib.concatMap (name:
    let path = dir + "/${name}";
        type = (builtins.readDir dir).${name};
    in
      if type == "directory"
      then listFilesRecursive path
      else [ path ]
  ) (builtins.attrNames (builtins.readDir dir));
```

[Source: nixpkgs/lib/filesystem.nix](https://github.com/NixOS/nixpkgs/blob/master/lib/filesystem.nix)

---

## Migration Guide

### Step 1: Backup

```bash
cp flake.nix flake.nix.backup
```

### Step 2: Replace flake.nix

```bash
mv flake.nix.new flake.nix
```

### Step 3: Test Templates

```bash
nix flake show
# Should show all templates auto-discovered

# Test a template
cd /tmp/test
nix flake init -t /home/guibaeta/Projects/flakes#default
nix develop
```

### Step 4: Test Packages

```bash
nix build .#auto-claude
./result/bin/auto-claude --help
```

### Step 5: Verify

```bash
# Check template count
nix eval .#templates --apply builtins.attrNames

# Check package count
nix eval .#packages.x86_64-linux --apply builtins.attrNames
```

---

## Future Enhancements

### 1. **Nested Package Discovery**

Support `packages/category/name/` structure:

```nix
discoverPackagesNested = system:
  # Walk directory tree recursively
  # Organize as packages.category.name
```

### 2. **Template Validation**

Validate templates have required files:

```nix
validateTemplate = path:
  assert builtins.pathExists (path + "/flake.nix");
  assert builtins.pathExists (path + "/.envrc");
  true;
```

### 3. **Metadata Files**

Support `meta.nix` for rich metadata:

```nix
# packages/auto-claude/meta.nix
{
  description = "...";
  tags = [ "ai" "coding" "electron" ];
  category = "development";
}
```

### 4. **Auto-Generated Docs**

Generate README sections automatically:

```nix
generatePackageDocs = packages:
  lib.concatStringsSep "\n\n" (
    lib.mapAttrsToList (name: pkg: ''
      ### ${name}
      ${pkg.meta.description or "No description"}
      `nix run .#${name}`
    '') packages
  );
```

---

## References

- [Nix Built-in Functions Reference](https://nix.dev/manual/nix/2.18/language/builtins)
- [Nix (builtins) & Nixpkgs (lib) Functions](https://teu5us.github.io/nix-lib.html)
- [nixos-generators Example](https://github.com/nix-community/nixos-generators/blob/master/flake.nix)
- [dream2nix Example](https://github.com/nix-community/dream2nix/blob/main/flake.nix)
- [nixpkgs/lib/filesystem.nix](https://github.com/NixOS/nixpkgs/blob/master/lib/filesystem.nix)

---

## Conclusion

This refactoring demonstrates Nix's power for:
- **Dynamic code generation**: Auto-discover filesystem structures
- **Convention over configuration**: Follow patterns, not boilerplate
- **DRY principle**: Single source of truth for metadata
- **Maintainability**: Add features by adding files, not editing code

The result is a more maintainable, scalable flake that grows with minimal manual intervention.

**Line count reduction:** 310 → 150 (52% reduction)
**Template addition effort:** 50 lines → 0 lines
**Package addition effort:** N/A → 0 lines (auto-discovered)
