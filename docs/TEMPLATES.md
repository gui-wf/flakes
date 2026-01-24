## Available Templates

### Default Template (General Purpose)
```bash
nix flake init -t github:gui-wf/flakes
# or explicitly:
nix flake init -t github:gui-wf/flakes#default
```
- Node.js + Python + essential tools
- Example package and app structure
- MCP server configuration

### Blender Template
```bash
nix flake init -t github:gui-wf/flakes#blender
```
- Blender for 3D modeling/animation
- uv for Python package management
- Blender-specific MCP server

## Common Dependencies

Base tools in all templates: `wget`, `yq`, `jq`, `nodejs`, `python3`
