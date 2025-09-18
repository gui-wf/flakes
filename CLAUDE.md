# Nix Flake Templates Repository

This repository contains Nix flake templates for development environments.

## Project Structure

- `flake.nix` - Main flake with template definitions
- `templates/` - Directory containing template implementations
- Each template includes `flake.nix` and `.mcp.json` configuration

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

### Zola Template
```bash
nix flake init -t github:gui-baeta/flakes#zola
```
- Zola static site generator
- General development workflows and documentation
- Comprehensive Zola development guidelines

### Zola-Blog-Init Template
```bash
nix flake init -t github:gui-baeta/flakes#zola-blog-init
```
- Specialized blog theme creation template
- Complete Zola blog theme development prompt with Claude Code integration
- Cloudflare Pages deployment configuration
- Production-ready theme creation guide with example prompts

## Common Dependencies

Base tools in all templates: `wget`, `yq`, `jq`, `nodejs`, `python3`

## Template Documentation

For detailed template examples and usage patterns, see [@docs/TEMPLATES.md](docs/TEMPLATES.md).

## Development Environment

To test templates locally:
```bash
nix develop  # Enter dev shell with common tools
```

## Nix Flake Template Best Practices

- Keep `buildInputs` organized by category (utilities, language tools, dev tools)
- Include helpful `shellHook` messages showing versions and available tools
- Use `flake-utils` for multi-system support
- Template paths must be relative to main flake.nix location

## MCP Server Configuration

All templates include `.mcp.json` with:
- Ref tools for documentation
- Sequential thinking for enhanced reasoning
- Perplexity for web search

Required environment variables: `REF_API_KEY`, `PERPLEXITY_API_KEY`

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
- **Principles**: Clear while concise, simplicity over complexity, be specific about backend/frontend, preserve reproduction steps and debugging context.
- **Examples**:
  - `AIDEV-TODO: Fix interaction dependency - MeToo query fires when uplift clicked, should be independent`
  - `AIDEV-TODO: Create meetverse entity on backend (as seed?) - get UUID from API or use local storage fallback`
  - `AIDEV-QUESTION: Should upvote deletion be implemented? Current: only creates, no toggle/removal exists`

### Accountability - when you don't know

- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## Template Maintenance

When adding new templates:
1. Create directory under `templates/`
2. Add `flake.nix` with proper `buildInputs`
3. Include `.mcp.json` configuration
4. Update main `flake.nix` templates section
5. Update README.md documentation

## File Modification Guidelines

- Always test templates locally before committing
- Maintain consistent formatting across all flake.nix files
- Keep dependencies up to date with nixpkgs-unstable
- Document any breaking changes in commit messages
