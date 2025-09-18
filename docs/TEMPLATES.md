## Available Templates

### Default Template (General Purpose)
```bash
nix flake init -t github:gui-baeta/flakes
# or explicitly:
nix flake init -t github:gui-baeta/flakes#default
```
- Node.js + Python + essential tools
- Example package and app structure
- MCP server configuration

### Blender Template
```bash
nix flake init -t github:gui-baeta/flakes#blender
```
- Blender for 3D modeling/animation
- uv for Python package management
- Blender-specific MCP server

## Common Dependencies

Base tools in all templates: `wget`, `yq`, `jq`, `nodejs`, `python3`
