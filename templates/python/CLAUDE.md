# Python Project Development Environment

This project uses Nix flakes for reproducible Python development environments with uv for fast package management.

## Development Environment

### Getting Started
```bash
# Enter development shell (auto-creates .venv)
nix develop

# Or with direnv (recommended)
echo "use flake" > .envrc
direnv allow
```

### Available Tools
- **Python 3** with virtual environment support
- **uv** for fast, modern package management
- **Python LSP Server** for IDE integration
- **Essential utilities**: wget, yq, jq for data processing
- **Development tools**: git, curl, tree

### Development Workflow
```bash
# Initialize a new project
uv init

# Install dependencies from pyproject.toml
uv sync

# Add a dependency
uv add requests

# Add a dev dependency
uv add --dev pytest

# Run Python commands in venv
uv run python script.py
uv run pytest
```

## MCP Server Configuration

This project includes `.mcp.json` with standard MCP servers:
- **Ref**: Documentation tools for libraries and frameworks
- **Sequential Thinking**: Enhanced reasoning for complex tasks
- **Perplexity**: Web search for up-to-date information

Required environment variables: `REF_API_KEY`, `PERPLEXITY_API_KEY`

## Customizing Your Environment

### Adding System Dependencies
Edit `flake.nix` to add Nix packages:
```nix
buildInputs = with pkgs; [
  # Existing packages...

  # Add your packages
  postgresql
  redis
  python3Packages.numpy
];
```

### Project Structure
```
my-project/
├── flake.nix           # Nix flake configuration
├── pyproject.toml      # Python project config
├── uv.lock             # Lock file (generated)
├── .venv/              # Virtual environment (generated)
├── src/
│   └── my_project/
│       └── __init__.py
└── tests/
    └── test_main.py
```

### pyproject.toml Example
```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "requests>=2.31.0",
]

[dependency-groups]
dev = [
    "pytest>=8.0.0",
    "ruff>=0.4.0",
]

[tool.ruff]
line-length = 88
target-version = "py311"
```

## AI Development Guidelines

### AI Notes and Breadcrumbs
- Use `AIDEV-NOTE:`, `AIDEV-TODO:`, or `AIDEV-QUESTION:` (all-caps prefix) text anchors for comments aimed at AI and developers.
- Keep them concise (120 chars max).
- **Important:** Before scanning files, always first try to **locate existing anchors** `AIDEV-*` in relevant subdirectories.
- **Update relevant anchors** when modifying associated code.
- **Do not remove `AIDEV-NOTE`s** without explicit human instruction.
- **Examples**:
  - `AIDEV-TODO: Add retry logic - API calls fail silently on network timeout, should retry 3x with backoff`
  - `AIDEV-QUESTION: Should we use async/await? Current: sync requests, blocks on I/O`

### Accountability - when you don't know
- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## Nix Commands Reference

```bash
# Development
nix develop              # Enter dev shell with venv
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

### Running Tests
```bash
# Run all tests
uv run pytest

# Run with coverage
uv run pytest --cov=src

# Run specific test file
uv run pytest tests/test_main.py
```

### Code Quality
```bash
# Format code
uv run ruff format .

# Lint code
uv run ruff check .

# Auto-fix issues
uv run ruff check --fix .
```

### FastAPI Project
```bash
uv add fastapi uvicorn
uv run uvicorn main:app --reload
```

### Environment Variables
Create a `.env` file for local configuration:
```bash
# .env (add to .gitignore)
DATABASE_URL=postgresql://localhost/mydb
DEBUG=true
```

Load in Python:
```python
from dotenv import load_dotenv
load_dotenv()
```
