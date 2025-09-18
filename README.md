# Super Mega Opinionated Flake Templates to Quick Start Projects
These are templates to make my life a little less frustrating. hopefully can help you too, fellow intern-aut

## Templates provided
This repository provides templates for:

- **General-purpose development** with Node.js, Python, and essential tools
- **Blender development** for 3D modeling and animation projects
- **Zola static sites** for fast, modern website generation
- **Zola blog themes** with comprehensive creation prompts and deployment guides
- **Example package and app** structures demonstrating Nix flake patterns
- **MCP server configurations** for enhanced AI assistance
- **Common utilities** (`wget`, `yq`, `jq`) included by default

## Quick Start

```bash
nix flake init -t github:gui-baeta/flakes
```

This creates a development environment perfect for exploring or starting any project.

## What's Included

### Development Environment
- **Node.js** with npm
- **Python 3** with pip
- **Essential utilities**: wget, yq, jq
- **Development tools**: git, curl, tree, nano, vim
- **MCP server configuration** for AI assistance

### Example Package & App
The template includes a demonstration bash script package that:
- Shows how to create packages in Nix flakes
- Uses `jq` as a dependency example
- Can be run with `nix run` or called directly in the dev shell

## Usage

### 1. Initialize Your Project
```bash
mkdir my-project
cd my-project
nix flake init -t github:gui-baeta/flakes
```

### 2. Enter Development Environment
```bash
nix develop
```

Or with direnv (recommended):
```bash
echo "use flake" > .envrc
direnv allow
```

### 3. Try the Example App
```bash
# Run the example script
nix run

# Or if you're in the dev shell:
hello-script
```

### 4. Start Building
The template provides a foundation. Modify `flake.nix` to:
- Add your preferred development tools
- Create your own packages
- Define custom apps
- Set up project-specific dependencies

## Template Features

### MCP Server Configuration
The template includes `.mcp.json` with pre-configured MCP servers:
- **Ref**: Reference and documentation tools
- **Sequential Thinking**: Enhanced reasoning capabilities
- **Perplexity**: Web search and research assistance

Set the required environment variables:
```bash
export REF_API_KEY="your-ref-api-key"
export PERPLEXITY_API_KEY="your-perplexity-api-key"
```

### Example Package Structure
The included `hello-script` demonstrates:
- Creating executable packages with `writeShellScriptBin`
- Using other Nix packages as dependencies
- Making packages available in both apps and devShells
- Proper package referencing with `${pkgs.jq}/bin/jq`

## Customization Examples

### Adding New Packages
```nix
buildInputs = with pkgs; [
  # Existing tools...

  # Add your tools
  docker
  terraform
  go
];
```

### Creating Your Own Package
```nix
my-tool = pkgs.writeShellScriptBin "my-tool" ''
  #!/usr/bin/env bash
  echo "My custom tool!"
  # Use dependencies: ${pkgs.somePackage}/bin/command
'';
```

### Adding Multiple Apps
```nix
apps = {
  default = {
    type = "app";
    program = "${hello-script}/bin/hello-script";
  };

  my-app = {
    type = "app";
    program = "${my-tool}/bin/my-tool";
  };
};
```

## Requirements

- Nix with flakes enabled
- Git (for template initialization)

### Enabling Nix Flakes
Add to your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

## Available Templates

### Default Template (Recommended)
```bash
nix flake init -t github:gui-baeta/flakes
```
General-purpose development environment with Node.js, Python, example package/app, and MCP configuration.

### Blender Template
```bash
nix flake init -t github:gui-baeta/flakes#blender
```
Specialized environment for Blender development with Blender, uv, and Blender MCP server.

### Zola Template
```bash
nix flake init -t github:gui-baeta/flakes#zola
```
Static site generator environment with Zola, includes `nix run` (serve) and `nix run .#build` commands.

### Zola-Blog-Init Template
```bash
nix flake init -t github:gui-baeta/flakes#zola-blog-init
```
Specialized template for creating complete Zola blog themes from scratch with detailed prompts for Cloudflare Pages deployment. Includes comprehensive CLAUDE.md with step-by-step implementation guide.

## Repository Structure

```
.
├── flake.nix                 # Main flake with template definitions
├── README.md                 # This file
├── CLAUDE.md                 # Claude Code memory file
└── templates/
    ├── default/              # Default template
    │   ├── flake.nix         # Template flake with example package/app
    │   ├── .mcp.json         # General MCP server configuration
    │   └── CLAUDE.md         # Default template AI guidelines
    ├── blender/              # Blender template
    │   ├── flake.nix         # Blender development environment
    │   ├── .mcp.json         # Blender MCP server configuration
    │   └── CLAUDE.md         # Blender-specific AI guidelines
    ├── zola/                 # Zola template
    │   ├── flake.nix         # Zola static site environment
    │   ├── .mcp.json         # General MCP server configuration
    │   └── CLAUDE.md         # Zola-specific AI guidelines
    └── zola-blog-init/       # Zola blog theme creation template
        ├── flake.nix         # Zola development environment
        ├── .mcp.json         # General MCP server configuration
        └── CLAUDE.md         # Blog theme creation prompt
```

## Contributing

Feel free to submit issues and pull requests to improve this template.

## License

This project is licensed under the MIT License.
