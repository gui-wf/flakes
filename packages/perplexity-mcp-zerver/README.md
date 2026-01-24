# perplexity-mcp-zerver

MCP server for Perplexity AI using browser automation (Puppeteer).

## Usage

```bash
# Run the MCP server
nix run github:gui-wf/flakes#perplexity-mcp-zerver
```

## Requirements

- Linux (Chromium/Puppeteer)
- First run will install dependencies and build

## MCP Client Configuration

Add to your MCP client config (e.g., Claude Desktop):

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "nix",
      "args": ["run", "github:gui-wf/flakes#perplexity-mcp-zerver"]
    }
  }
}
```

## Features

- Intelligent web research with deep searches
- Persistent conversations (local SQLite storage)
- Content extraction for URLs and GitHub repos
- No API key required (uses browser automation)

## Data Storage

Data is stored in `~/.local/share/perplexity-mcp-zerver/`

## License

GPL-3.0 (upstream project)
