# Project Development Environment

This project uses Nix flakes for reproducible development environments.

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
- **Node.js** with npm for JavaScript/TypeScript development
- **Python 3** with pip for Python development  
- **Essential utilities**: wget, yq, jq for data processing
- **Development tools**: git, curl, tree, nano, vim

### Example Package
This template includes a sample `hello-script` package demonstrating:
- Creating executable packages with Nix
- Using dependencies (jq) within packages
- Apps configuration for `nix run`

Try: `nix run` or `hello-script` (in dev shell)

## MCP Server Configuration

This project includes `.mcp.json` with pre-configured MCP servers for enhanced AI assistance:
- **Ref**: Reference and documentation tools
- **Sequential Thinking**: Enhanced reasoning capabilities
- **Perplexity**: Web search and research assistance

Set environment variables:
```bash
export REF_API_KEY="your-ref-api-key"
export PERPLEXITY_API_KEY="your-perplexity-api-key"
```

## Customizing Your Environment

### Adding Dependencies
Edit `flake.nix` to add packages:
```nix
buildInputs = with pkgs; [
  # Existing packages...
  
  # Add your packages
  docker
  terraform
  go
];
```

### Creating Custom Packages
```nix
my-tool = pkgs.writeShellScriptBin "my-tool" ''
  #!/usr/bin/env bash
  echo "Custom tool"
  # Use dependencies: ${pkgs.somePackage}/bin/command
'';
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
- **Principles**: Clear while concise, simplicity over complexity, be specific about backend/frontend, preserve reproduction steps and debugging context.
- **Examples**:
  - `AIDEV-TODO: Fix interaction dependency - MeToo query fires when uplift clicked, should be independent`
  - `AIDEV-TODO: Create meetverse entity on backend (as seed?) - get UUID from API or use local storage fallback`
  - `AIDEV-QUESTION: Should upvote deletion be implemented? Current: only creates, no toggle/removal exists`

### Accountability - when you don't know
- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## Nix Commands Reference

```bash
# Development
nix develop              # Enter dev shell
nix run                 # Run default app
nix build               # Build default package

# Flake management
nix flake update        # Update flake.lock
nix flake check         # Validate flake
nix flake show          # Show flake outputs

# Cleanup
nix-collect-garbage     # Clean old generations
```