# Blender Project Development Environment

This project uses Nix flakes for reproducible Blender development environments.

## Development Environment

### Getting Started
```bash
# Enter development shell
nix develop

# Or with direnv (recommended)
echo "use flake" > .envrc
direnv allow
```

### Available Tools
- **Blender** for 3D modeling, animation, and rendering
- **uv** for modern Python package management
- **Python 3** with pip for scripting and addon development
- **Essential utilities**: wget, yq, jq for data processing
- **Development tools**: git, curl, tree, nano, vim

### Blender Development
```bash
# Launch Blender
blender

# Open specific file
blender path/to/file.blend

# Run Blender in background (headless)
blender --background --python script.py
```

## MCP Server Configuration

This project includes `.mcp.json` with Blender MCP server for enhanced AI assistance with Blender development:
- **Blender MCP**: Specialized assistance for Blender scripting and workflows

The Blender MCP server uses `uvx` to run `blender-mcp` for Blender-specific AI assistance.

## Customizing Your Environment

### Adding Dependencies
Edit `flake.nix` to add packages:
```nix
buildInputs = with pkgs; [
  # Existing packages...
  
  # Add your packages
  blender-addons
  python3Packages.mathutils
  python3Packages.bpy
];
```

### Blender Python Scripts
Create Python scripts for Blender automation:
```python
import bpy

# Example: Clear default objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
```

## AI Development Guidelines

### AI Notes and Breadcrumbs
- Use `AIDEV-NOTE:`, `AIDEV-TODO:`, or `AIDEV-QUESTION:` (all-caps prefix) text anchors for comments aimed at AI and developers.
- Keep them concise (≤ 120 chars).
- **Important:** Before scanning files, always first try to **locate existing anchors** `AIDEV-*` in relevant subdirectories.
- **Anchors** can and may mention Plane Work Items or GitHub Issues.
- **Update relevant anchors** when modifying associated code.
- **Do not remove `AIDEV-NOTE`s** without explicit human instruction.
- **Convert any existing TODOs to AIDEV format** preserving debugging context and reproduction steps.
- **Structure**:
  - **What**: Action needed (concise)
  - **Why**: Context/constraint (brief)
  - **How to reproduce**: Steps when applicable
  - **Current vs expected**: State difference
- **Principles**: Clear while concise, simplicity over complexity, be specific about Blender scripting/modeling context, preserve reproduction steps and debugging context.
- **Examples**:
  - `AIDEV-TODO: Fix animation keyframe interpolation - curves snap to linear instead of bezier, breaks smooth motion`
  - `AIDEV-TODO: Add material validation - current shader nodes missing normal map input, causes flat rendering`
  - `AIDEV-QUESTION: Should we use Cycles or Eevee for final render? Current: Eevee preview, no production config`

### Accountability - when you don't know
- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## Nix Commands Reference

```bash
# Development
nix develop              # Enter dev shell with Blender
nix run                 # Run default app (if defined)
nix build               # Build default package (if defined)

# Flake management
nix flake update        # Update flake.lock
nix flake check         # Validate flake
nix flake show          # Show flake outputs

# Cleanup
nix-collect-garbage     # Clean old generations
```

## Blender-Specific Notes

### Python Path
Blender includes its own Python interpreter. For addon development, you may need to:
```bash
# Install packages for Blender's Python
uv pip install --target ~/.config/blender/scripts/modules package-name
```

### Addon Development
- Place addons in `~/.config/blender/scripts/addons/`
- Use `bl_info` dictionary for addon metadata
- Test with Blender's built-in addon preferences