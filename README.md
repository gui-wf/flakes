# Development Templates & Packages

Quick-start templates and reusable packages for common development environments.

## What is a Nix Flake?

Think of a Nix flake as a **reproducible development environment in a file**. It:
- Defines exactly what tools and versions you need
- Works the same way on any computer
- Can be shared with others (they'll get the exact same setup)
- Doesn't pollute your global system

**Example**: Instead of "install Node.js globally, hope it's the right version, install packages, cross fingers", you run `nix develop` and get **exactly** the environment you need, every time.

## What This Repository Provides

### Packages (Reusable Software)

| Package | Description | Usage |
|---------|-------------|-------|
| **auto-claude** | Autonomous multi-agent coding framework (Electron app) | `nix run github:gui-wf/flakes#auto-claude` |
| **markdownify** | MCP server converting files to Markdown (PDF, Word, Excel, etc.) | `nix run github:gui-wf/flakes#markdownify` |
| **pdf2epub-mcp-server** | PDF to EPUB converter with intelligent layout detection | `nix run github:gui-wf/flakes#pdf2epub-mcp-server input.pdf` |

### Templates (Project Starters)

| Template | Tools Included | Use Case |
|----------|----------------|----------|
| **default** | Node.js, Python, jq, git | General development |
| **nodejs** | Node.js 22, npm, TypeScript LSP | JavaScript/TypeScript projects |
| **python** | Python 3, uv, venv, LSP | Python projects |
| **blender** | Blender, Python, uv | 3D modeling/animation |
| **zola** | Zola static site generator | Static websites |
| **zola-blog-init** | Zola + blog theme prompts | Blog creation |
| **mcp-server** | Node.js, TypeScript, sops, age | MCP server development |

## Quick Start

### Use a Template

```bash
# Start a new project with a template
mkdir my-project && cd my-project
nix flake init -t github:gui-wf/flakes#nodejs

# Enter the development environment
nix develop

# Or use direnv for automatic activation
echo "use flake" > .envrc && direnv allow
```

### Use a Package

```bash
# Run auto-claude directly
nix run github:gui-wf/flakes#auto-claude

# Or install it
nix profile install github:gui-wf/flakes#auto-claude
```

### Use in Your Own Flake

```nix
{
  inputs.dev-flakes.url = "github:gui-wf/flakes";

  outputs = { self, nixpkgs, dev-flakes }: {
    # Use a package
    packages.x86_64-linux.default =
      dev-flakes.packages.x86_64-linux.auto-claude;

    # Inherit a template
    templates.my-template = dev-flakes.templates.nodejs;
  };
}
```

## How It Works (Auto-Discovery)

This repository uses Nix's built-in functions to **automatically discover** templates and packages:

- **Templates**: Any directory in `templates/` becomes a template
- **Packages**: Any directory in `packages/` with `package.nix` becomes a package

**To add your own:**
```bash
# Add a template - just create a directory
mkdir templates/rust
# Add files (flake.nix, etc.)
# Done! Available as: nix flake init -t .#rust

# Add a package - just create a directory
mkdir packages/my-tool
# Add package.nix
# Done! Available as: nix build .#my-tool
```

No need to edit the main `flake.nix` - everything is discovered automatically using `builtins.readDir` and `lib.mapAttrs`.

## Requirements

**Nix with flakes enabled**:
```bash
# Add to ~/.config/nix/nix.conf or /etc/nix/nix.conf
experimental-features = nix-command flakes
```

Install Nix: https://nixos.org/download

## Structure

```
flakes/
├── flake.nix              # Auto-discovers templates & packages
├── templates/             # Project starter templates
│   ├── default/
│   ├── nodejs/
│   ├── python/
│   └── ...
└── packages/              # Reusable software packages
    └── auto-claude/
```

## Technical Details

- **Auto-discovery**: Uses `builtins.readDir` to scan directories
- **Metadata extraction**: Pulls descriptions from `flake.nix` and `CLAUDE.md`
- **Zero boilerplate**: Add a directory, it's instantly available
- **Type-safe**: Only processes valid directories with required files

See [IMPLEMENTATION_ANALYSIS.md](./IMPLEMENTATION_ANALYSIS.md) for technical deep-dive.

## Contributing

Add templates or packages by creating directories in `templates/` or `packages/` - they'll be auto-discovered.

## License

MIT License
