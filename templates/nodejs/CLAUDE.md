# Node.js Project Development Environment

This project uses Nix flakes for reproducible Node.js development environments.

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
- **Node.js 22** with npm for JavaScript/TypeScript runtime
- **TypeScript Language Server** for IDE integration
- **Essential utilities**: wget, yq, jq for data processing
- **Development tools**: git, curl, tree

### Development Workflow
```bash
# Initialize a new project
npm init -y

# Install dependencies
npm install

# Start development server (if configured)
npm run dev

# Build for production
npm run build
```

## MCP Server Configuration

This project includes `.mcp.json` with standard MCP servers:
- **Ref**: Documentation tools for libraries and frameworks
- **Sequential Thinking**: Enhanced reasoning for complex tasks
- **Perplexity**: Web search for up-to-date information

Required environment variables: `REF_API_KEY`, `PERPLEXITY_API_KEY`

## Customizing Your Environment

### Adding Dependencies
Edit `flake.nix` to add Nix packages:
```nix
buildInputs = with pkgs; [
  # Existing packages...

  # Add your packages
  yarn
  pnpm
  nodePackages.prettier
];
```

### Adding npm Scripts
Edit `package.json`:
```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "test": "vitest"
  }
}
```

## AI Development Guidelines

### AI Notes and Breadcrumbs
- Use `AIDEV-NOTE:`, `AIDEV-TODO:`, or `AIDEV-QUESTION:` (all-caps prefix) text anchors for comments aimed at AI and developers.
- Keep them concise (120 chars max).
- **Important:** Before scanning files, always first try to **locate existing anchors** `AIDEV-*` in relevant subdirectories.
- **Update relevant anchors** when modifying associated code.
- **Do not remove `AIDEV-NOTE`s** without explicit human instruction.
- **Examples**:
  - `AIDEV-TODO: Fix async state update - component unmounts before fetch completes, causes memory leak`
  - `AIDEV-QUESTION: Should we use React Query or SWR for data fetching? Current: raw fetch with useState`

### Accountability - when you don't know
- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## Nix Commands Reference

```bash
# Development
nix develop              # Enter dev shell
nix run                  # Run default app (if defined)
nix build                # Build default package (if defined)

# Flake management
nix flake update         # Update flake.lock
nix flake check          # Validate flake
nix flake show           # Show flake outputs

# Cleanup
nix-collect-garbage      # Clean old generations
```

## Common Patterns

### Environment Variables
Create a `.env` file for local configuration:
```bash
# .env (add to .gitignore)
API_URL=http://localhost:3000
DEBUG=true
```

### TypeScript Setup
```bash
npm install -D typescript @types/node
npx tsc --init
```

### Vite Project
```bash
npm create vite@latest my-app -- --template react-ts
cd my-app && npm install
npm run dev
```
